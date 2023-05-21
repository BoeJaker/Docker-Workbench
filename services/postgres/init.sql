CREATE DATABASE msfdb_prod;
CREATE DATABASE msfdb_dev;
CREATE DATABASE msfdb_test;
CREATE DATABASE logs;

-- Switch to the newly created database or the existing one
\c logs;

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS logspout (
  id SERIAL PRIMARY KEY,
  timestamp TIMESTAMP DEFAULT NOW(),
  container_name TEXT,
  log_level TEXT,
  message TEXT
);


CREATE TABLE IF NOT EXISTS fluentd (
  id SERIAL PRIMARY KEY,
  tag TEXT,  
  time TIMESTAMPTZ,
  log TEXT
);

