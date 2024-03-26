# Use an official Selenium base image with Chrome
FROM selenium/standalone-chrome:latest
USER root
# Set the working directory to /usr/src/app
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any dependencies
# (Note: You may need to install additional dependencies based on your requirements)
RUN apt-get update && \
    apt-get install -y python3

# Set environment variables
ENV CHROME_DRIVER_VERSION 95.0.4638.17

# Download and install ChromeDriver
RUN wget -q "https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip" -O chromedriver.zip && \
    unzip chromedriver.zip && \
    chmod +x chromedriver && \
    mv chromedriver /usr/local/bin/

# Command to run on container start
CMD ["python3", "your_script.py"]
