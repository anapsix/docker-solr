FROM anapsix/alpine-java:jre8
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## Env
ENV SOLR_VERSION 5.2.0
ENV SOLR solr-$SOLR_VERSION
ENV JDBC_MYSQL_VERSION 5.1.35
ENV JDBC_PSQL_VERSION 9.3-1103.jdbc41
##
#

#
## Install
RUN [ -e /sbin/apk ] && ( [ -e /bin/bash ] || apk add --update bash ) || \
    ( [ -e /usr/bin/apt-get ] && ( apt-get update && apt-get install -y patch unzip && apt-get clean all && which unzip && which patch ) || echo "no \"apk\", no \"apt-get\", what are you running, Gentoo?" ) && \
    echo "getting solr $SOLR_VERSION" >&2 && \
    wget -q http://mirrors.gigenet.com/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz -O /tmp/$SOLR.tgz && \
    mkdir -p /opt && \
    gzip -dc /tmp/$SOLR.tgz | tar -C /opt -x && \
    ln -sf /opt/$SOLR /opt/solr && \
    echo "getting PSQL JDBC" >&2 && \
    wget -q http://jdbc.postgresql.org/download/postgresql-$JDBC_PSQL_VERSION.jar -O /opt/solr/dist/postgresql-$JDBC_PSQL_VERSION.jar && \
    echo "getting MYSQL JDBC" >&2 && \
    wget -q http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz -O /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz && \
    echo mysql-connector-java-$JDBC_MYSQL_VERSION/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar > /tmp/include && \
    gzip -dc /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz | tar -x -T /tmp/include > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar && \
    echo "fixing naturalSort.js (see https://issues.apache.org/jira/browse/SOLR-7588)" >&2 && \
    wget -q https://issues.apache.org/jira/secure/attachment/12738314/SOLR-7588.patch -O /tmp/SOLR-7588.patch && \
    mkdir /opt/solr/server/solr-webapp/webapp && \
    unzip -q -d /opt/solr/server/solr-webapp/webapp /opt/solr/server/webapps/solr.war && \
    patch -p0 /opt/solr/server/solr-webapp/webapp/js/lib/naturalSort.js < /tmp/SOLR-7588.patch && \
    echo "cleaning up.." >&2 && \
    rm -rf /tmp/*
##
#

EXPOSE 8983
ADD ./docker-entrypoint.sh /entrypoint.sh
WORKDIR /opt/solr
ENTRYPOINT ["/entrypoint.sh"]
