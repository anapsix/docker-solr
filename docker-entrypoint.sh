#!/bin/bash
set -e

trap 'echo "Shutting down..."; exit 0' SIGINT

if [ -z "$1" ]; then
  exec bin/solr start -force -f
elif [[ "${1:0:1}" == '-' ]]; then
  exec bin/solr start -force -f "$@"
  for ((i=10;i--;i>0)); do
    LOG="$(find ./ -name "solr.log" -mtime -1)"
    if [ -n "$LOG" ]; then
      tail -f $LOG
    else
      echo "waiting for log for example \"$2\" to become available.."
      echo "${i} seconds remaining.."
    fi
    sleep 1
  done
else
  exec "$@"
fi


echo "fin."

