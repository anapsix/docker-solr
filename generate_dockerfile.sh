#!/bin/bash
# re-generate Dockerfile for requested variantsribution(s)
# works with GNU bash only

declare -A variants
variants[alpine-oracle-java8]="anapsix/alpine-java"
variants[openjdk-java8]="java:8-jre"
variants[oracle-java8]="anapsix/docker-oracle-java8"
DOCKERFILE_TEMPLATE=Dockerfile

for variant in ${!variants[@]}; do
  test -d variants/$variant || mkdir variants/$variant
  sed "s/^FROM.*/FROM ${variants[$variant]/\//\\/}/g" Dockerfile > variants/$variant/Dockerfile
    cp ./docker-entrypoint.sh variants/$variant/
done
