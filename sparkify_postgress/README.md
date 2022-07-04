# Data Modeling with Postgres

## **Purpose**
A startup wants to analyze the data they've been collecting on songs and user's activity on their new music streaming app. Their area of intereset is to understand what songs user are listening.
The data is currently in JSON log format and un-strucutred to fullfill the ananlytics need.
We need to design an ETL pipeline using postgress database and python.

## **Enviroment**
**Laungauge**: Python(3.x), SQL\
**Database**: Postgress\
**Dependency**: psycopg2, pandas, ipython-sql\
**Editor**: VSCode, DataGrip, JupyterLab

## **Schema**
#### Fact Table 

**songplays** - records in log data associated with song plays i.e. records with page `NextSong`
```
songplay_id, start_time, user_id, level, song_id, artist_id, session_id, location, user_agent
```
#### Dimension Tables
**users**  - users in the app
```
user_id, first_name, last_name, gender, level
```
**songs**  - songs in music database
```
song_id, title, artist_id, year, duration
```
**artists**  - artists in music database
```
artist_id, name, location, latitude, longitude
```
**time**  - timestamps of records in  **songplays**  broken down into specific units
```
start_time, hour, day, week, month, year, weekday
```

## **Files**
- **test.ipynb** displays the first few rows of each table to let you check your database.
- **create_tables.py** drops and creates your tables. You run this file to reset your tables before each time you run your ETL scripts.
- **etl.ipynb** reads and processes a single file from song_data and log_data and loads the data into your tables. This notebook contains detailed instructions on the ETL process for each of the tables.
- **etl.py** reads and processes files from song_data and log_data and loads them into your tables. You can fill this out based on your work in the ETL notebook.
- **sql_queries.py** contains all your sql queries, and is imported into the last three files above.
- **README.md** provides discussion on your project.

## **How To Run**

In ```create_tables.py``` change the **username**, **password** and default **databasename** in line number **13** according to your configuration
```
conn = psycopg2.connect("host=127.0.0.1 dbname=studentdb user=student password=student")
```
And make similar changes in ```etl.py``` in line number **92**
```
conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=student password=student")
```
### **Now after setup**
1- Run ``create_tables.py``
```
python create_tables.py
```
2- Run ``test.ipynb`` to confirm the creation of your tables with the correct columns. Make sure to click "Restart kernel" to close the connection to the database after running this notebook. \
3- Run ``etl.py``
```
python etl.py
```
4- Again run ``test.ipynb`` to confirm the entries.

