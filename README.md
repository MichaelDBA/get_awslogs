# get_awslogs
Simplify process of getting AWS logs for PostgreSQL  using AWS CLI APIs

(c) 2021 SQLEXEC LLC
<br/>
GNU V3 and MIT licenses are conveyed accordingly.
<br/>
Bugs can be reported by creating an issue here, https://github.com/MichaelDBA/get_awslogs/issues/new/choose.
<br/>
Please provide example code along with issues reported if possible.
<br/>

## Overview
This bash script encapsulates downloading PostgreSQL logs from AWS. 

Parameters:
-p PROFILE: AWS profile from AWS config file
-f DBID: AWS DB Identifier
-a ACTION: RUN or PRINT
-n NUMLOGS: ALL or specific hour suffix
-d DATE: DATE in format, yyyy-mm-dd
-l LOGDIR: fully qualified path to the log directory where downloaded logs are stored.
<br/><br/>
## Examples
getawslogs.sh -p prod -f alliance-cdb-prd -a RUN   -n ALL -d 2021-03-29 -l /var/lib/pgsql/als/logs
<br/>
getawslogs.sh -p prod -f alliance-cdb-prd -a RUN -n 06 -d 2021-03-29 -l /var/lib/pgsql/als/logs
<br/>
getawslogs.sh -p prod -f alliance-cdb-prd -a PRINT -n ALL -d 2021-03-29 -l /var/lib/pgsql/als/logs
<br/>
