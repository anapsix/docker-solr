FROM anapsix/busybox-java
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## install required utils
RUN [ -e /etc/opkg.conf ] && opkg-install bash; [ -e /bin/bash ]
RUN [ -e /usr/bin/apt-get ] && apt-get update && apt-get install -y patch unzip && apt-get clean all; which unzip && which patch
##
#

#
## SOLR INSTALLATION
ENV SOLR_VERSION 5.2.0
ENV SOLR solr-$SOLR_VERSION
ADD http://mirrors.gigenet.com/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt \
 && gzip -dc /tmp/$SOLR.tgz | tar -C /opt -x \
 && ln -sf /opt/$SOLR /opt/solr \
 && rm /tmp/$SOLR.tgz
##
#

#
## Patch naturalSort.js
## See https://issues.apache.org/jira/browse/SOLR-7588
ADD https://issues.apache.org/jira/secure/attachment/12738314/SOLR-7588.patch /tmp/SOLR-7588.patch
RUN mkdir /opt/solr/server/solr-webapp/webapp \
 && unzip -d /opt/solr/server/solr-webapp/webapp /opt/solr/server/webapps/solr.war \
 && patch -p0 /opt/solr/server/solr-webapp/webapp/js/lib/naturalSort.js < /tmp/SOLR-7588.patch \
 && rm /tmp/SOLR-7588.patch
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
RUN echo mysql-connector-java-$JDBC_MYSQL_VERSION/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar > /tmp/include \
 && gzip -dc /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz | tar -x -T /tmp/include > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar \
 && rm -rf /tmp/*
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

