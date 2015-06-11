docker-solr
===================

SOLR 5.2 with Java8 (openjdk-8-jre-headless) over Debian 8 aka Jessie
includes JDBC for PostgreSQL (9.3-1103.jdbc41) and MySQL (5.1.35)

## Usage

**NEW**: you can now pass arguments to solr directly.
> Try `docker run -it anapsix/solr -e techproducts`

See `docker run -it anapsix/solr -help` for available command line arguments

------

Here is how I start the container, while mounting Solr Core settings inside the container instance.

    #!/bin/bash
    # start.sh
    # Stat an instance of Solr container with Core config mounted
    #

    HOST_PROXY_PORT=8983
    CONTAINER_SOLR_PORT=8983

    self_path="$(readlink -e $0)"
    APP_DIR="${self_path%%/${self_path##*/}}"
    CONTAINER_PATH="/opt/solr"

    COLLECTIONS=$(find ${APP_DIR} -maxdepth 1 -mindepth 1 -type d -not -name .git -printf "%f\n")
    VOLUMES=$(for col in ${COLLECTIONS[*]}; do echo -en "-v ${APP_DIR}/${col}:${CONTAINER_PATH}/server/solr/${col} "; done)

    start_container() {
      APP_CID=$(docker run \
        -d \
        --name=solr \
        -p ${HOST_PROXY_PORT}:${CONTAINER_SOLR_PORT} \
        $VOLUMES \
        anapsix/docker-solr)
      RETVAL=$?
      [ $RETVAL -eq 0 ] && echo "you may access container via http://$(hostname -i):${HOST_PROXY_PORT}/solr" >&2
      return $RETVAL
    }

    start_container
    exit 0



I place this script (start.sh) into directory containing my "cores". Each core is within it's own directory:

    |- start.sh
    |-core1/
    |     |-conf/
    |     |     |-data-config.xml
    |     |     |-schema.xml
    |     |     |...
    |     |-core.properties
    |-core2/
          |-conf/
          |     |-data-config.xml
          |     |-schema.xml
          |     |...
          |-core.properties

and just run start.sh
