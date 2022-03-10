cls
@echo off
if [%1]==[] goto  :blank
if %1 == start goto :start 
if %1 == stop goto  :stop 
if %1 == restart goto  :restart 
if %1 == console goto  :console 
if %1 == load goto  :load 
goto :end

:blank
ECHO hbf
ECHO -- start ( starts PostGIS, Hasura, PGAdmin; Migrations, Seeds, Metadata)
ECHO -- restart (stop + start)
ECHO -- stop ( stops PostGIS, Hasura, PGAdmin)
ECHO -- console (starts admin console)
ECHO -- load (Migrations, Seeds, Metadata)
goto end

:console
ECHO Open console
cd ./hasura-server
hasura console
cd ..
goto end

:load
ECHO Loading data
CALL  hasura migrate apply --admin-secret secret --database-name default 
ECHO  Created database tables
timeout 10 
CALL  hasura seeds apply  --admin-secret secret --database-name default 
ECHO  Data seeded
timeout 10 
CALL  hasura metadata  --admin-secret secret apply	
goto end

:stop
ECHO Stop
docker-compose down 
ECHO Docker-compose down done
goto end

:start
ECHO Start
cd ./hasura-server
START /W docker-compose pull
ECHO Docker-compose pull done 
START /W docker-compose up -d
ECHO Docker-compose up done
ECHO HBF started
goto end

:restart
ECHO Restart
START /W docker-compose down 
ECHO Docker-compose down done
timeout 30
START /W docker-compose pull
ECHO Docker-compose pull done 
START /W docker-compose up -d
ECHO Docker-compose up done
ECHO HBF started
goto end

:end 
ECHO READY 


