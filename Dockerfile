FROM anapsix/docker-oracle-java8
MAINTAINER Anastas Dancha "anapsix@random.io"

#
## SOLR INSTALLATION
ENV SOLR_VERSION 4.10.0
ENV SOLR solr-$SOLR_VERSION
ADD http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt
RUN tar -C /opt -xf /tmp/$SOLR.tgz
RUN ln -sf /opt/$SOLR /opt/solr
##
#

EXPOSE 8983
CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"]
