#!/bin/bash
#waits for private token and stage name
#return names of failed jobs in stage
GITLAB_URL=$(echo $CI_PROJECT_URL | grep -Eo 'http.?://[^/]*')
GITLAB_PIPLINE_URL="$GITLAB_URL"'/api/v4/projects/'"$CI_PROJECT_ID"'/pipelines/'"$CI_PIPELINE_ID"

function get_stage_failed_jobs (){
    curl -s -g --header "PRIVATE-TOKEN: $1" "$GITLAB_PIPLINE_URL"'/jobs?scope[]=failed' | jq --arg stage "$2" -c '.[] | select(.stage==$stage) | .name'
}
