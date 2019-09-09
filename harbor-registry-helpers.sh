#!/bin/bash

function get_key_tags (){
    local host=$1
    local user=$2
    local pass=$3
    local reg_key=$4
    local token=$(curl -s -u ${user}:${pass} -H "Content-Type: application/json" -X GET https://${host}/service/token?service=harbor-registry\&scope=repository:${reg_key} | jq -r .token)
    curl -s -H "Content-Type: application/json" -H "Authorization:  Bearer ${token}" -X GET https://${host}/v2/${reg_key}/tags/list | jq -r .tags
}

function key_tag_exists (){
    #will return "null" if tag not exists in repo
    local host=$1
    local user=$2
    local pass=$3
    local reg_key=$4
    local tag=$5
    local token=$(curl -s -u ${user}:${pass} -H "Content-Type: application/json" -X GET https://${host}/service/token?service=harbor-registry\&scope=repository:${reg_key} | jq -r .token)
    curl -s -H "Content-Type: application/json" -H "Authorization:  Bearer ${token}" -X GET https://${host}/v2/${reg_key}/tags/list \
    | jq --arg tag "$tag" -c '.tags | index( $tag )'
}