#!/bin/bash

function slack_notify_failed_jobs() {
 SLACK_WEBHOOK_URL=$1
 SLACK_CHANNEL=$2
 SLACK_USER_NAME=$3
 if [ -z "${4}" ]; then
    exit 0
 fi
 echo "
 Triggered by: $GITLAB_USER_LOGIN
 Pipline number: $CI_PIPELINE_ID
 Failed jobs:
 $4
 " | slackr -w $SLACK_WEBHOOK_URL -r $SLACK_CHANNEL -c warn -n "$SLACK_USER_NAME" -t "Failed build for $CI_ENVIRONMENT_NAME environment"
}
