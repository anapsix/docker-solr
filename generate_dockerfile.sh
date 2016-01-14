#!/bin/bash
# re-generate Dockerfile for requested variants/dist
# works with GNU bash only
set -e

declare -A variants
variants[alpine-oracle-java8]="anapsix/alpine-java"
variants[openjdk-java8]="java:8-jre"
variants[oracle-java8]="anapsix/docker-oracle-java8"
DOCKERFILE_TEMPLATE=Dockerfile

for variant in ${!variants[@]}; do
  test -d variants/$variant || mkdir variants/$variant
  echo -n "generating Dockerfile for ${variant}:" >&2
  sed "s/^FROM.*/FROM ${variants[$variant]/\//\\/}/g" Dockerfile > variants/$variant/Dockerfile && \
  cp ./docker-entrypoint.sh variants/$variant/ && \
  echo " ok" || echo " failed"
done
