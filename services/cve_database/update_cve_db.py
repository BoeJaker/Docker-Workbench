#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup
import psycopg2
import time
import os
import json

# PostgreSQL database connection details
db_host = os.getenv('DB_HOST')
db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')

# NVD CVE feed URL
nvd_cve_feed_url = 'https://services.nvd.nist.gov/rest/json/cves/1.0'

# MITRE ATT&CK URL
mitre_url = 'https://attack.mitre.org/software/'

# Establish PostgreSQL connection
conn = psycopg2.connect(host=db_host, dbname=db_name, user=db_user, password=db_password)
cursor = conn.cursor()

# Create CVE table if it doesn't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS cve (
        id SERIAL PRIMARY KEY,
        cve_id VARCHAR(50),
        description TEXT,
        cvss_score FLOAT,
        cvss_severity VARCHAR(20)
    );
""")
conn.commit()

# Create software_toolsets table if it doesn't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS software_toolsets (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        description TEXT
    );
""")
conn.commit()

# Function to retrieve CVEs from NVD and store them in the database
def fetch_cves():
    response = requests.get(nvd_cve_feed_url)
    print(response.content)
    data = response.json()

    for cve_entry in data['result']['CVE_Items']:
        cve_id = cve_entry['cve']['CVE_data_meta']['ID']
        description = cve_entry['cve']['description']['description_data'][0]['value']
        try:
            cvss_score = cve_entry['impact']['baseMetricV3']['cvssV3']['baseScore']
            cvss_severity = cve_entry['impact']['baseMetricV3']['cvssV3']['baseSeverity']
        except:
            cvss_score = 0
            cvss_severity = "Not Found"
        
        cursor.execute("""
            INSERT INTO cve (cve_id, description, cvss_score, cvss_severity)
            VALUES (%s, %s, %s, %s)
        """, (cve_id, description, cvss_score, cvss_severity))

    conn.commit()
    print("CVEs added to the database.")

# Function to fetch software and toolset information from MITRE ATT&CK
def fetch_software_toolsets():
    response = requests.get(mitre_url)
    soup = BeautifulSoup(response.text, 'html.parser')
    software_toolsets = soup.select('table.table>tbody>tr')

    for row in software_toolsets:
        name = row.select_one('td:nth-of-type(1)').text.strip()
        description = row.select_one('td:nth-of-type(2)').text.strip()

        cursor.execute("""
            INSERT INTO software_toolsets (name, description)
            VALUES (%s, %s)
        """, (name, description))
        print(name, description)

    conn.commit()
    print("Software and toolsets added to the database.")

# Main loop to run the script repeatedly
while True:
    # Fetch and store CVEs
    fetch_cves()

    # Fetch and store software and toolsets
    fetch_software_toolsets()

    # Delay for 24 hours before the next update
    time.sleep(24 * 60 * 60)

# Close the database connection
cursor.close()
conn.close()
