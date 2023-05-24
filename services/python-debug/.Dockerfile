FROM python:3

# Install required libraries for GUI
RUN apt-get update 
RUN apt-get -y install pip

RUN pip install objbrowser
RUN pip install PyQt6

# Set environment variables
ENV DISPLAY=host.docker.internal:0

# Copy and run your Python application
COPY your_script.py /app/your_script.py
RUN git pull ${PYTHON_GIT_REPO} /app
WORKDIR /app
RUN pip install requirements.txt

CMD ["echo", "Starting Python Dev Environment \n Starting ${PYTHON_GIT_REPO}...", \
    "echo", "Starti
    "python", "your_script.py"]

