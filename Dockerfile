FROM ubuntu
RUN apt-get update && apt-get install -y locales python-numpy libicu-dev python-dev python-pip

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

WORKDIR /opt/app/
EXPOSE 5001
ADD requirements.txt .
RUN pip install -r requirements.txt
RUN mkdir /root/polyglot_data
RUN polyglot download embeddings2.en ner2.en
ADD app.py .
ENV FLASK_APP app.py
ENV FLASK_DEBUG 0
CMD flask run --host 0.0.0.0 --port 5001 --with-threads
