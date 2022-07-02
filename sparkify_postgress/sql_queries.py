# DROP TABLES

songplay_table_drop = "DROP TABLE  IF EXISTS songplays"
user_table_drop = "DROP TABLE IF EXISTS  users"
song_table_drop = "DROP TABLE IF EXISTS  songs"
artist_table_drop = "DROP TABLE  IF EXISTS artists"
time_table_drop = "DROP TABLE  IF EXISTS time"

# CREATE TABLES

songplay_table_create = ("""
CREATE TABLE IF NOT EXISTS songplays
(
    songplay_id SERIAL PRIMARY KEY,
    start_time  TIMESTAMP,
    user_id     INT,
    level       VARCHAR NOT NULL,
    song_id     VARCHAR,
    artist_id   VARCHAR,
    session_id  INT     NOT NULL,
    location    VARCHAR,
    user_agent  TEXT
)
""")

user_table_create = ("""
CREATE TABLE IF NOT EXISTS users
(
    user_id    INT PRIMARY KEY,
    first_name VARCHAR,
    last_name  VARCHAR,
    gender     CHAR(1),
    level      VARCHAR NOT NULL
)
""")

song_table_create = ("""
CREATE TABLE IF NOT EXISTS songs
(
    song_id   VARCHAR PRIMARY KEY,
    title     VARCHAR,
    artist_id VARCHAR,
    year      INT,
    duration  FLOAT
)
""")

# https://stackoverflow.com/questions/1196415/what-datatype-to-use-when-storing-latitude-and-longitude-data-in-sql-databases
# best practise to save latitude and longitude
artist_table_create = ("""
CREATE TABLE IF NOT EXISTS artists
(
    artist_id VARCHAR PRIMARY KEY,
    name      VARCHAR,
    location  VARCHAR,
    latitude  DECIMAL(9, 6),
    longitude DECIMAL(9, 6)
)
""")

time_table_create = ("""
CREATE TABLE IF NOT EXISTS time
(
    start_time TIMESTAMP PRIMARY KEY,
    hour       INT     NOT NULL CHECK (hour >= 0),
    day        INT     NOT NULL CHECK (day >= 0),
    week       INT     NOT NULL CHECK (week >= 0),
    month      INT     NOT NULL CHECK (month >= 0),
    year       INT     NOT NULL CHECK (year >= 0),
    weekday    VARCHAR NOT NULL
)
""")

# INSERT RECORDS

songplay_table_insert = ("""
INSERT INTO songplays (start_time, user_id, level, song_id, artist_id, session_id, location, user_agent)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
""")
# duplicate key value violates unique constraint "users_pkey"
user_table_insert = ("""
INSERT INTO users (user_id, first_name, last_name, gender, level)
values (%s, %s, %s, %s, %s)
ON CONFLICT (user_id) DO UPDATE SET level = EXCLUDED.level
""")

song_table_insert = ("""
INSERT INTO songs (song_id, title, artist_id, year, duration)
values (%s, %s, %s, %s, %s)
ON CONFLICT (song_id) DO NOTHING
""")

artist_table_insert = ("""
INSERT INTO artists (artist_id, name, location, latitude, longitude)
values (%s, %s, %s, %s, %s)
ON CONFLICT (artist_id) DO NOTHING
""")

time_table_insert = ("""
INSERT INTO time (start_time, hour, day, week, month, year, weekday)
values (%s, %s, %s, %s, %s, %s, %s)
ON CONFLICT (start_time) DO NOTHING
""")

# FIND SONGS
# INNER JOIN = JOIN
song_select = ("""
SELECT song_id, artists.artist_id
FROM songs
         INNER JOIN artists ON artists.artist_id = songs.artist_id
WHERE title = %s
  AND name = %s
  AND duration = %s
""")

# QUERY LISTS

create_table_queries = [songplay_table_create, user_table_create, song_table_create, artist_table_create,
                        time_table_create]
drop_table_queries = [songplay_table_drop, user_table_drop, song_table_drop, artist_table_drop, time_table_drop]
