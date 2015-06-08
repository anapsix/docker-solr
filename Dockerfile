FROM anapsix/docker-oracle-java8
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## SOLR INSTALLATION
ENV SOLR_VERSION 5.2.0
ENV SOLR solr-$SOLR_VERSION
ADD http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt
RUN tar -C /opt -xf /tmp/$SOLR.tgz
RUN ln -sf /opt/$SOLR /opt/solr
##
#

#
## JDBC
ENV JDBC_MYSQL_VERSION 5.1.35
ENV JDBC_PSQL_VERSION 9.3-1103.jdbc41
# PostgreSQL
ADD http://jdbc.postgresql.org/download/postgresql-$JDBC_PSQL_VERSION.jar /opt/solr/dist/postgresql-$JDBC_PSQL_VERSION.jar
# MySQL
ADD http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz
RUN tar -x -f /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz --wildcards --no-anchored mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar --to-stdout > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar
##
#

#
## CLEANUP
RUN rm -rfv /tmp/*
##
#

EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr; ./bin/solr start -f"]
