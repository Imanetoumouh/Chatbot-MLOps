FROM python:3.9-slim-buster

WORKDIR /app

COPY . /app
#RUN pip install -r requirements.txt

RUN pip install spacy>=3.2 && \
    pip install spacy download en_core_web_sm && \
    pip install -r requirements.txt

CMD ["python3", "chatbot_flask.py"]
