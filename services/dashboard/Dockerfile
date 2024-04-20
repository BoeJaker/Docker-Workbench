# Use an official Python runtime as a parent image
FROM python:3.8-slim

RUN apt install openldap-client

RUN pip install docker flask

COPY ./Landing_Page.py /Landing_Page.py

CMD ["sh", "-c", "python /Landing_Page.py"]