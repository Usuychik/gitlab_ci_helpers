#!/bin/bash

# PARAMS
# $1 = k8s namespace
# $2 = k8s configmap name
# $3 = source file for configmap
function deploy_configmap() {
    set +e
    (kubectl get configmap/$2 --namespace=$1)
    if [[ $? -eq 0 ]]
    then
        set -e
        kubectl create configmap $2 --namespace=$1 --from-env-file=$3  -o yaml --dry-run | kubectl replace -f -
    else
        set -e
        kubectl create configmap $2 --namespace=$1 --from-env-file=$3
    fi
}

# PARAMS
# $1 = k8s namespace
# $2 = k8s configmap name
# $3 = source file for configmap
function deploy_configmap_from_env_file() {
    set +e
    (kubectl get configmap/$2 --namespace=$1)
    if [[ $? -eq 0 ]]
    then
        set -e
        kubectl create configmap $2 --namespace=$1 --from-env-file=$3  -o yaml --dry-run | kubectl replace -f -
    else
        set -e
        kubectl create configmap $2 --namespace=$1 --from-env-file=$3
    fi
}

# PARAMS
# $1 = k8s namespace
# $2 = k8s configmap name
# $3 = source file for configmap
# $4 = section name for source file
function deploy_configmap_from_conf_file() {
    set +e
    (kubectl get configmap/$2 --namespace=$1)
    if [[ $? -eq 0 ]]
    then
        set -e
        kubectl create configmap $2 --namespace=$1 --from-file=$4=$3  -o yaml --dry-run | kubectl replace -f -
    else
        set -e
        kubectl create configmap $2 --namespace=$1 --from-env-file=$3
    fi

}

# PARAMS
# $1 = GCLOUD_SERVICE_FILE_JSON
# $2 = GOOGLE_PROJECT_ID
# $3 = GOOGLE_COMPUTE_ZONE
# $4 = GOOGLE_CLUSTER_NAME
function gke_set_config(){
    gcloud auth activate-service-account --key-file=${1}
    gcloud --quiet config set project ${2}
    gcloud --quiet config set compute/zone ${3}
    gcloud --quiet container clusters get-credentials ${4}
}

# PARAMS
# $1 = k8s namespace
# $2 = k8s deployment name
# $3 = optional wait time in minutes, default 10
function reload_pods_in_deployment(){
  if [ -z ${3+x} ]
  then
    timeout=10m
  else
    timeout=$3m
  fi

  # check if deployment exists
  set +e
  (kubectl get deployment/$2 -n $1)
  if [[ $? -ne 0 ]]
  then
    return 0
  fi
  set -e
  dummy_date=$(date +'%s')
  kubectl patch deployment/$2 -n $1 -p \
     "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"dummy-date\":\"$dummy_date\"}}}}}"

  kubectl rollout status deployment/$2 -n $1 --timeout=$timeout
}

# PARAMS
# $1 = result of kubectl apply
function check_if_deployment_changed(){
  set +e
  (echo $1 | grep -q "deployment.apps/[A-Za-z-]* unchanged")
  echo $?
  set -e
}
