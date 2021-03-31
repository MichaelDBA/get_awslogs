#!/bin/bash
# getawslogs.sh
# https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-log-files.html

while getopts p:f:a:n:d:l: option
do
case "${option}"
in
p) PROFILE=${OPTARG};;
f) DBID=${OPTARG};;
a) ACTION=${OPTARG};;
n) NUMLOGS=${OPTARG};;
d) DATE=${OPTARG};;
l) LOGDIR=${OPTARG};;
esac
done
args=$#
if [ $args -ne 12 ]; then
    echo "invalid number of arguments provided: $args.  Expected 6.  getawslogs.sh -p <profile>  -f <DBID>  -a <ACTION>  -n <NUMLOGS>  -d <DATE>  -l <LOGDIR>"
    exit 1
fi

if [ -z "$ACTION" ]; then
    echo "No action provided."
    exit 1
elif [ -z "$NUMLOGS" ]; then
    echo "Number of logs not provided."
    exit 1    
elif [ -z "$DATE" ]; then
    echo "No date provided."
    exit 1
elif [ -z "$PROFILE" ]; then
    echo "No profile provided."
    exit 1
elif [ -z "$DBID" ]; then
    echo "No DB Identifier provided."
    exit 1
elif [ -z "$LOGDIR" ]; then
    echo "No Output log directory provided."
    exit 1    
elif [ "$ACTION" != "RUN" ] && [ "$ACTION" != "PRINT" ]; then
    echo "Invalid action provided.  Options are RUN or PRINT."
    exit 1
fi

echo "Using profile=$PROFILE  DBID=$DBID  action=$ACTION  numlogs=$NUMLOGS  DATE=$DATE  LOGDIR=$LOGDIR"
today=`date +"%Y-%m-%d"`
echo "Getting candidate logs for date: $DATE"

LOGLIST=`aws rds describe-db-log-files --db-instance-identifier $DBID --profile $PROFILE --file-size 1 --filename-contains $DATE | grep -i logfilename | cut -f2 -d: |  tr -d ',' | tr -d '\"'`
#echo $LOGLIST
i=0
while IFS=' ' read -ra ADDR; do
  for alog in "${ADDR[@]}"; do
    newfile=${alog/error\/}
    outfile="$newfile"
    #newfile="\"$alog\""
    if [[ "$NUMLOGS" != "ALL" ]]; then
       if [[ "$alog" != *"$NUMLOGS" ]]; then
           echo "bypassing log,   $alog"
           continue
       fi
    fi
    if [ $ACTION == "RUN" ]; then
        echo "downloading log, $alog"
        aws rds download-db-log-file-portion --db-instance-identifier alliance-cdb-prd --profile $PROFILE --log-file-name $alog  --starting-token 0 --output text > $LOGDIR/$outfile.log
    elif [ $ACTION == "PRINT" ]; then
        echo "aws rds download-db-log-file-portion --db-instance-identifier alliance-cdb-prd --profile $PROFILE --log-file-name $alog  --starting-token 0 --output text > $LOGDIR/$outfile.log"
    fi

    ((i=i+1))
  done
  #if [ $i -eq 3 ]; then break; fi
done <<< "$LOGLIST"
exit 0
