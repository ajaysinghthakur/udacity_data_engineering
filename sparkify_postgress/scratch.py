import json
import os
import glob
import psycopg2
import pandas as pd
from pyparsing import line
from sql_queries import *


conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=ajaysinghthakur password=ajay")
cur = conn.cursor()


def get_files(filepath):
    all_files = []
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root,'*.json'))
        for f in files :
            all_files.append(os.path.abspath(f))
    
    return all_files


song_files = get_files("./data/song_data/")


filepath = song_files[0]

print(filepath)
df = pd.DataFrame([pd.read_json(filepath, typ='series', convert_dates=False)])
df.head()

song_data = df[['song_id', 'title', 'artist_id', 'year', 'duration']].values[0]
print(song_data)

cur.execute(song_table_insert, song_data)
conn.commit()


artist_data = df[['artist_id','artist_name', 'artist_location', 'artist_latitude', 'artist_longitude']].values[0]
print(artist_data)

cur.execute(artist_table_insert, artist_data)
conn.commit()


log_files = get_files("./data/log_data")

filepath = log_files[0]


df = pd.read_json(filepath, lines=True)
df.head()

df = df[df['page']=='NextSong']
df.head()

t = pd.to_datetime(df['ts'], unit='ms')
t.head()

time_data = (t, t.dt.hour.values, t.dt.day.values, t.dt.weekofyear.values, t.dt.month.values, t.dt.year.values, t.dt.weekday.values )
column_labels = (["start_time", "hour", "day", "week of year", "month", "year", "weekday"])

time_df = pd.DataFrame(dict(zip(column_labels, time_data)))
time_df.head()

for i, row in time_df.iterrows():
    cur.execute(time_table_insert, list(row))
    conn.commit()
    print(list[row])

user_df = df[['userId', 'firstName', 'lastName', 'gender', 'level']]
user_df.head()


for i, row in user_df.iterrows():
    cur.execute(user_table_insert, row)
    conn.commit()
    print(row)


for index, row in df.iterrows():

    # get songid and artistid from song and artist tables
    cur.execute(song_select, (row.song, row.artist, row.length))
    results = cur.fetchone()
    
    if results:
        songid, artistid = results
    else:
        songid, artistid = None, None

    # # insert songplay record
    songplay_data = (pd.to_datetime(row.ts, unit='ms'), row.userId, row.level, songid, artistid, row.sessionId, row.location, row.userAgent)
    cur.execute(songplay_table_insert, songplay_data)
    conn.commit()
    print(index)
    print(row)

conn.close()
