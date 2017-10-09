docker-solr
===================

Few variants of an image with SOLR 7.0.1 over Java8, includes JDBC for PostgreSQL (9.4.1207-42) and MySQL (5.1.38).  
Alpine image also includes BASH, OpenSSL and ca-certificates packages.

[![](https://badge.imagelayers.io/anapsix/solr:latest.svg)](https://imagelayers.io/?images=anapsix/solr:latest)

| tag                          | description                      | size |
| ---------------------------- | -------------------------------- | ---- |
| 7 / latest | Solr 6 & Oracle Java8 over AlpineLinux    | [![](https://badge.imagelayers.io/anapsix/solr:latest.svg)](https://imagelayers.io/?images=anapsix/solr:latest) |
| 6 | Solr 6 & Oracle Java8 over AlpineLinux    | [![](https://badge.imagelayers.io/anapsix/solr:latest.svg)](https://imagelayers.io/?images=anapsix/solr:6) |
| 5 / 5-alpine-oracle-java8 | Solr 5 & Oracle Java8 over AlpineLinux    | [![](https://badge.imagelayers.io/anapsix/solr:latest.svg)](https://imagelayers.io/?images=anapsix/solr:5) |
| 5-oracle-java8                 | Solr 5 & Oracle Java8 over Ubuntu Trusty  | [![](https://badge.imagelayers.io/anapsix/solr:oracle-java8.svg)](https://imagelayers.io/?images=anapsix/solr:5-oracle-java8) |
| 5-openjdk-java8                | Solr 5 & OpenJDK Java8 over Debian Jessie | [![](https://badge.imagelayers.io/anapsix/solr:openjdk-java8.svg)](https://imagelayers.io/?images=anapsix/solr:5-openjdk-java8) |

## Usage

Here is how I start the container, while mounting Solr core directories inside the container instance.

    #!/bin/bash
    # start.sh
    # Start an instance of Solr container with cores mounted
    #

    SOLR_IMAGE="anapsix/solr"
    HOST_PROXY_PORT=8983
    CONTAINER_SOLR_PORT=8983

    self_path="$(readlink -e $0)"
    APP_DIR="${self_path%%/${self_path##*/}}"
    CONTAINER_PATH="/opt/solr"

    COLLECTIONS=$(find ${APP_DIR} -maxdepth 1 -mindepth 1 -type d -not -name .git -printf "%f\n")
    VOLUMES=$(for col in ${COLLECTIONS[*]}; do echo -en "-v ${APP_DIR}/${col}:${CONTAINER_PATH}/server/solr/${col} "; done)

    start_container() {
      docker run -d \
        --name=solr \
        -p ${HOST_PROXY_PORT}:${CONTAINER_SOLR_PORT} \
        $VOLUMES \
        $SOLR_IMAGE >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "you may access container via http://$(hostname -i):${HOST_PROXY_PORT}/solr" >&2
    else
      echo "failed to start cotnainer"
      exit 1
    fi



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
