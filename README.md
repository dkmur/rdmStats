# rdmStats

at the time of writing this nothing has been tested so WIP is an understatement :p

tbd:
- add grafana templates
- add worker stats when available in rdm
- once worker stats have been added it will allow to link them to device info such as restarts/reboots

## 1 Prerequisites
- only tested on mariadb 10.5
- on rdm enable ????

## 2 Setup
- clone rdmStats, `git clone https://github.com/dkmur/rdmStats.git`
- copy and fill out config, `cd rdmStats/ && cp default_files/config.ini.example config.ini`
- execute setting.run
- add content of crontab.txt to your cron
- add quest and mon area fences to table geofences and execute settings.run once more to populate column `st`
```
insert ignore into geofences (area,fence,type,coords) values
('Newyork','Newyork_centre','mon','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

insert ignore into geofences (area,fence,type,coords) values
('Newyork','Newyork_south','mon','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

insert ignore into geofences (area,type,coords) values
('Newyork','quest','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

- column fence is only used in case you use subfences for an area(town), will default to area when not included
- first and last coordinate must be the same for column coords
- after changing or adding fences always execute setting.run to populate column st
```

## 3 Grafana
- Install Grafana, more details can be found at https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository or if you prefer to use docker <https://hub.docker.com/r/grafana/grafana>
- Create datasource on rdmStats db
- Add datasource name to config.ini
- After executing settings.run, import the dashboards from rdmStats/grafana by selecting ``+`` and then import


## 4 Updates
- depending on changes but to be safe, pull+execute settings.run+update crontab
- replace changed grafana templates
<BR>
<BR>
A logs folder will be created in rdmStats folder, any errors during execution are printed before the actual logline.
