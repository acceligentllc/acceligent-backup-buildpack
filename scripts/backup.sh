#!/bin/bash

DBNAME=""
Green='\033[0;32m'
EC='\033[0m' 
FILENAME=`date +%H_%M_%d%m%Y`

# terminate script on any fails
set -e

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -exp|--expiration)
    EXPIRATION="$2"
    shift
    ;;
    -db|--dbname)
    DBNAME="$2"
    shift
    ;;
esac
shift
done

if [[ -z "$POSTGRES_HOST" ]]; then
  echo "Missing POSTGRES_HOST variable. Exiting with 1."
  exit 1
fi
if [[ -z "$POSTGRES_DBNAME" ]]; then
  echo "Missing POSTGRES_DBNAME variable. Exiting with 1."
  exit 1
fi
if [[ -z "$POSTGRES_USERNAME" ]]; then
  echo "Missing POSTGRES_USERNAME variable. Exiting with 1."
  exit 1
fi
if [[ -z "$POSTGRES_PASSWORD" ]]; then
  echo "Missing POSTGRES_PASSWORD variable. Exiting with 1."
  exit 1
fi
if [[ -z "$AWS_S3_ACCESS_KEY" ]]; then
  echo "Missing AWS_S3_ACCESS_KEY variable. Exiting with 1."
  exit 1
fi
if [[ -z "$AWS_S3_SECRET" ]]; then
  echo "Missing AWS_S3_SECRET variable. Exiting with 1."
  exit 1
fi
if [[ -z "$AWS_S3_BUCKET_NAME" ]]; then
  echo "Missing AWS_S3_BUCKET_NAME variable. Exiting with 1."
  exit 1
fi

printf "${Green}Start dump${EC}"

time pg_dump -b -F c --dbname=$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST/$POSTGRES_DBNAME | gzip >  /tmp/"${DBNAME}_${FILENAME}".gz

printf "${Green}Move dump to AWS${EC}"
time /app/vendor/awscli/bin/aws s3 cp /tmp/"${DBNAME}_${FILENAME}".gz s3://$AWS_S3_BUCKET_NAME/backup/"${DBNAME}_${FILENAME}".gz

# remove temp file
rm -rf /tmp/"${DBNAME}_${FILENAME}".gz