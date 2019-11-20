FROM openjdk:8

RUN apt-get update
RUN apt-get -y install supervisor python-pip net-tools vim
RUN pip install supervisor-stdout
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV VERSION 1.5.0
ENV DESTINATION /opt/hbase

COPY hbase-${VERSION}-bin.tar.gz /
RUN tar -xvf hbase-${VERSION}-bin.tar.gz
RUN mv /hbase-${VERSION} ${DESTINATION}
ADD hbase-site.xml /${DESTINATION}/conf/hbase-site.xml
ADD hbase-env.sh /${DESTINATION}/conf/hbase-env.sh

# Folder for data
RUN mkdir -p /data/hbase
RUN mkdir -p /data/zookeeper

ENV JAVA_HOME /usr/local/openjdk-8
ENV PATH $PATH:/${DESTINATION}/bin

# Getting web-for-it
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# REST API
EXPOSE 8080
# Thrift API
EXPOSE 9090

# Zookeeper port
EXPOSE 2181

# Master port
EXPOSE 16000
# Master info port
EXPOSE 16010

# Regionserver port
EXPOSE 16020
# Regionserver info port
EXPOSE 16030

VOLUME /data/hbase
VOLUME /data/zookeeper
WORKDIR ${DESTINATION}


CMD ["/usr/bin/supervisord"]
