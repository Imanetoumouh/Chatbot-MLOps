# Use a specific TensorFlow version
FROM tensorflow/tensorflow:latest

# For more information, please refer to https://aka.ms/vscode-docker-python
#FROM python:3.10-slim

# Set the working directory
WORKDIR /app
## Copy files
COPY preprocess_data.py /app/
COPY train_chatbot_model.py /app/
COPY chatbot_flask.py /app/
COPY requirements.txt /app/

# Install spaCy and download language model
RUN python -m pip install spacy>=3.2 && \
    python -m spacy download en_core_web_sm

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy only the necessary data file (intents.json) into the container at /app
COPY intents.json /app/intents.json

# Set environment variable for NLTK data directory
#ENV NLTK_DATA=/home/appuser/nltk_data

# Copy the punkt.zip file into the container
#COPY punkt.zip /home/appuser/nltk_data/tokenizers/punkt.zip

# Run data preprocessing
RUN python /app/preprocess_data.py

# Train the model
RUN python /app/train_chatbot_model.py

#RUN python /app/chatbot_flask.py

# Set the working directory
#WORKDIR /app

EXPOSE 5000

# Keeps Python from generating .pyc files in the container
#ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
#ENV PYTHONUNBUFFERED=1

# Install system dependencies
#RUN apt-get update && apt-get install -y --no-install-recommends nvidia-cuda-toolkit

# Set environment variables
#ENV CUDA_VISIBLE_DEVICES=0

# Install pip requirements
#COPY requirements.txt .
#RUN python -m pip install spacy>=3.2 && \
#    python -m spacy download en_core_web_sm && \
#    python -m pip install -r requirements.txt

# Download NLTK data separately on the host machine
#RUN python -m nltk.downloader punkt

#COPY intents.json /app/intents.json
# Copy the application code into the container
#COPY . .


#WORKDIR /app
#COPY . /app

# Debugging: Display the content of the /app directory
#RUN ls -al /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "chatbot_flask:app"]
#CMD ["--bind", "0.0.0.0:5000", "chatbot_flask:app"]

# Command to run the Flask app using Gunicorn
#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--log-level", "debug", "chatbot_flask:app"]

# Command to run your application
CMD ["python", "chatbot_flask.py"]
