FROM anapsix/docker-oracle-java8
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## SOLR INSTALLATION
ENV SOLR_VERSION 5.2.0
ENV SOLR solr-$SOLR_VERSION
ADD http://mirrors.gigenet.com/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt \
 && tar -C /opt -xf /tmp/$SOLR.tgz \
 && ln -sf /opt/$SOLR /opt/solr \
 && rm -v /tmp/$SOLR.tgz
##
#

#
## Patch naturalSort.js
## See https://issues.apache.org/jira/browse/SOLR-7588
RUN apt-get update \
 && apt-get install -y patch unzip \
 && unzip -d /opt/solr/server/solr-webapp/webapp /opt/solr/server/webapps/solr.war \
 && wget -q --no-check-certificate -O - https://issues.apache.org/jira/secure/attachment/12738314/SOLR-7588.patch | patch -p0 /opt/solr/server/solr-webapp/webapp/js/lib/naturalSort.js \
 && apt-get clean all
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
RUN tar -x -f /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz --wildcards --no-anchored mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar --to-stdout > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar \
 && rm -rfv /tmp/*
##
#

#
## CLEANUP
#RUN rm -rfv /tmp/*
##
#

EXPOSE 8983
ADD ./docker-entrypoint.sh /entrypoint.sh
WORKDIR /opt/solr
ENTRYPOINT ["/entrypoint.sh"]
