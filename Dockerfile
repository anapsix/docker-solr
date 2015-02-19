FROM anapsix/docker-oracle-java8
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## SOLR INSTALLATION
ENV SOLR_VERSION 4.10.3
ENV SOLR solr-$SOLR_VERSION
ADD http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt
RUN tar -C /opt -xf /tmp/$SOLR.tgz
RUN ln -sf /opt/$SOLR /opt/solr
##
#

#
## JDBC
# PostgreSQL
ADD http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar /opt/solr/dist/postgresql-9.3-1102.jdbc41.jar
# MySQL
ADD http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz /tmp/mysql-connector-java-5.0.8.tar.gz
RUN tar -x -f /tmp/mysql-connector-java-5.0.8.tar.gz --wildcards --no-anchored mysql-connector-java-5.0.8-bin.jar --to-stdout > mysql-connector-java-5.0.8-bin.jar
##
#

#
## CLEANUP
RUN rm -rfv /tmp/*
##
#

EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"]
