#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 1440 mon area stats
if "$monareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb < $folder/default_files/1440_mon_area.sql.default
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 mon area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

