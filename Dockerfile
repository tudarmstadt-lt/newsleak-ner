FROM ubuntu
RUN apt-get update && apt-get install -y python-numpy libicu-dev python-dev python-pip
WORKDIR /opt/app/
EXPOSE 5001
ADD requirements.txt .
RUN pip install -r requirements.txt
RUN polyglot download embeddings2.en embeddings2.de ner2.en ner2.de
ADD app.py .
ENV FLASK_APP app.py
ENV FLASK_DEBUG 0
CMD flask run --host 0.0.0.0 --port 5001