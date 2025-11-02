import duckdb
import os

DB_FILE = 'data/connectsphere.duckdb'
RAW_DATA_DIR = 'data/raw'

# Remove old database file if it exists to ensure a fresh start
if os.path.exists(DB_FILE):
    os.remove(DB_FILE)

con = duckdb.connect(database=DB_FILE, read_only=False)

print("Database created. Creating tables...")

# Create tables from Parquet/CSV files
con.execute(f"CREATE TABLE events AS SELECT * FROM read_parquet('{RAW_DATA_DIR}/events.parquet');")
con.execute(f"CREATE TABLE users AS SELECT * FROM read_parquet('{RAW_DATA_DIR}/users.parquet');")
con.execute(f"CREATE TABLE reviews AS SELECT * FROM read_csv_auto('{RAW_DATA_DIR}/app_store_reviews.csv');")

print("Tables created successfully:")
print(con.execute("SHOW TABLES;").fetchdf())

con.close()
print("Database initialization complete.")