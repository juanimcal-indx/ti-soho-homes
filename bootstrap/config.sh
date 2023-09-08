#!/usr/bin/env bash

# DEPENDENCIES
DEPENDENCIES=("git" "terraform")

# GCP
GCP_PROFILE=ti-ex
GCP_SA_JSON_PATH="${HOME}/Downloads/arboreal-parser-236919-44cc9a693634.json"
export TF_VAR_gcp_region=europe-southwest1
export TF_VAR_gcp_zone=europe-southwest1-a
export TF_VAR_project_id=arboreal-parser-236919 
export TF_VAR_cloud_storage_sa="$(gsutil kms serviceaccount -p ${TF_VAR_project_id})"
export GOOGLE_APPLICATION_CREDENTIALS=${GCP_SA_JSON_PATH}
