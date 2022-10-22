#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 15 quest area stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mysql -u$sqluser -p$sqlpass -h$dbip -P$dbport $rdmstatsdb -NB -e "call rpl15questarea();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl15 quest area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 15 mon area stats
if "$monareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mysql -u$sqluser -p$sqlpass -h$dbip -P$dbport $rdmstatsdb -e "call rpl15monarea();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl15 mon area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# table cleanup pokemon_history
if [[ ! -z $pokemon_history ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  mysql -h$dbip -P$dbport -u$sqluser -p$sqlpass $scannerdb -e "delete from pokemon_history where expire_timestamp < unix_timestamp(now() - interval $pokemon_history day);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup table pokemon_history" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 15 spawnpoint area stats
if "$monareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mysql -u$sqluser -p$sqlpass -h$dbip -P$dbport $rdmstatsdb -NB -e "call rpl15spawnarea();"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl15 spawnpoint area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi
