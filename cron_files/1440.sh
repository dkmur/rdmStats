#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 1440 spawnpoint area stats
if "$spawnpointareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb < $folder/default_files/1440_spawnpoint.sql.default
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 spawnpoint area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 quest area stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb < $folder/default_files/1440_quest_area.sql.default
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 quest area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 atlas log stats
if "$atlas_monitor"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb < $folder/default_files/1440_atlaslog.sql.default
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 atlas log processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

## Cleanup stats tables
# cleanup mon_area, spawnpoint and quest
if [[ ! -z $area_rpl15 ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_mon_area where rpl = 15 and datetime < now() - interval $area_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_mon_area where rpl = 60 and datetime < now() - interval $area_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_mon_area where rpl = 1440 and datetime < now() - interval $area_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_mon_area where rpl = 10080 and datetime < now() - interval $area_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_quest_area where rpl = 15 and datetime < now() - interval $area_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_quest_area where rpl = 60 and datetime < now() - interval $area_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_quest_area where rpl = 1440 and datetime < now() - interval $area_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_quest_area where rpl = 10080 and datetime < now() - interval $area_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_spawnpoint where rpl = 15 and datetime < now() - interval $area_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_spawnpoint where rpl = 60 and datetime < now() - interval $area_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $rdmstatsdb -e "delete from stats_spawnpoint where rpl = 1440 and datetime < now() - interval $area_rpl1440 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup table stats_mon_area+stats_spawnpoint+stats_quest_area" >> $folder/logs/log_$(date '+%Y%m').log
fi
