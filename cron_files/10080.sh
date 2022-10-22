#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 10080 quest stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mysql -h$dbip -P$dbport -u$sqluser -p$sqlpass $rdmstatsdb < $folder/default_files/10080_quest_area.sql.default
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl10080 queat area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi
