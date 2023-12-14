FROM python:3.9-slim-buster

WORKDIR /app
COPY . /app
#RUN pip install -r requirements.txt

# Install spaCy and download language model
RUN pip install spacy>=3.2 && \
    python -m spacy download en_core_web_sm

# Install other requirements
RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["python3", "chatbot_flask.py"]
