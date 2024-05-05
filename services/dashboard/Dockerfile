# Use an official Python runtime as a parent image
FROM python:3.8-slim

RUN pip install docker flask
# RUN chmod +x app/gsheetoauth.py

# Generate SSH key for https
# RUN openssl req -x509 -newkey rsa:4096 -keyout /key.pem -out /cert.pem -days 365 -passout pass:password -subj "/CN=example.com/O=My Organization/C=US"
# COPY ./Landing_Page.py /Landing_Page.py
# COPY ./templates /templates
# Run script.py when the container launches
# CMD ["python3", "/Landing_Page.py"]
CMD ["sh", "-c", "while :; do sleep 10; done"]