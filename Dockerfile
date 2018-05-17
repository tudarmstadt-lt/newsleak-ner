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
RUN polyglot download TASK:ner2
RUN polyglot download embeddings2.ar embeddings2.bg embeddings2.ca embeddings2.cs embeddings2.da embeddings2.de embeddings2.el embeddings2.en embeddings2.es embeddings2.et embeddings2.fa embeddings2.fi embeddings2.fr embeddings2.he embeddings2.hi embeddings2.hr embeddings2.hu embeddings2.id embeddings2.it embeddings2.ja embeddings2.ko embeddings2.lt embeddings2.lv embeddings2.ms embeddings2.nl embeddings2.no embeddings2.pl embeddings2.pt embeddings2.ro embeddings2.ru embeddings2.sk embeddings2.sl embeddings2.sr embeddings2.sv embeddings2.th embeddings2.tl embeddings2.tr embeddings2.uk embeddings2.vi embeddings2.zh
ADD app.py .
ENV FLASK_APP app.py
ENV FLASK_DEBUG 0
CMD flask run --host 0.0.0.0 --port 5001 --with-threads
