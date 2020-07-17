# !/bin/bash
source aws.flush-env

ACCT=${1}
ROLE_ARN=`sed -nr "/^\[profile\ $ACCT\]/ { :l /^role_arn[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" ~/.aws/config`
CREDS=`aws sts assume-role --role-arn=$ROLE_ARN --role-session-name=$ACCT`

export AWS_ACCESS_KEY_ID=`echo $CREDS | jq -r '.Credentials.AccessKeyId'`
export AWS_SECRET_ACCESS_KEY=`echo $CREDS | jq -r '.Credentials.SecretAccessKey'`
export AWS_SESSION_TOKEN=`echo $CREDS | jq -r '.Credentials.SessionToken'`

EXPIRES=`echo $CREDS | jq -r '.Credentials.Expiration'`
echo Expires at: $EXPIRES

printenv | grep AWS
