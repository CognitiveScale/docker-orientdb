#!/bin/bash
#
database_dir=/opt/orientdb/databases

if [ -d "${database_dir}/GratefulDeadConcerts" ];then
  echo "GratefulDeadConcerts database found."
else
  echo "installing GratefulDeadConcerts"
/opt/orientdb/bin/console.sh <(echo 'connect remote:localhost root root ; create database remote:localhost/GratefulDeadConcerts root root plocal; import database /opt/orientdb/GratefulDeadConcerts.gz')
fi
