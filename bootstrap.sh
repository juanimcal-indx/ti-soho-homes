#!/usr/bin/env bash

set -eo pipefail
# readonly REPO_ROOT=$(git rev-parse --show-toplevel)
# source "${REPO_ROOT}/bootstrap/config.sh"
source "./bootstrap/config.sh"

usage() {
cat<<EOF
Bootstrap Current Environment To Run TI Exercise
  Usage: $(basename $0) 
    -h  Optional
        Display Help
EOF
}

exit_error() {
  usage
  exit 1
}

guard_command() {
  if ! command -v "${1}" > /dev/null; then
    echo "[DEPENDENCIES] - [guard_command()] ${1} command not installed, it's required, you cannot continue without it"
    exit 1
  fi
}

verify_dependencies() {
  echo -e "\n#### Checking Dependencies ####"
  for dep in ${DEPENDENCIES[@]}; do
    echo "Checking if ${dep} is available"
    guard_command "${dep}"
  done
}

setup_gcloud() {
  local profile

  echo -e "\n#### Creating/Configuring Google Cloud Profile ${GCP_PROFILE} ####"
  profile=$(gcloud config configurations list --filter="NAME=${GCP_PROFILE}" --format="value[](name)")

  if [[ -z "${profile}" ]]; then
    gcloud config configurations create "${GCP_PROFILE}"
  fi
  
  gcloud auth activate-service-account --key-file="${GCP_SA_JSON_PATH}" 
  gcloud config set project "${TF_VAR_project_id}" --quiet
  gcloud config set compute/zone "${TF_VAR_gcp_zone}" --quiet
}

main() {
  # inputs
#   local item="${1}"
#   local status="${2:-}"

  verify_dependencies
  setup_gcloud

}

# .............................................................................
# ENTRYPOINT
# .............................................................................
unset -v INPUT_ITEM INPUT_STATUS
while getopts :h opts; do
  case "${opts}" in
    # i)
    #   INPUT_ITEM="${OPTARG}" ;;
    # s)
    #   INPUT_STATUS="${OPTARG}" ;;
    h)
      usage
      exit 0 
      ;;
    *)
      exit_error ;;
  esac
done

# if [[ -z "${INPUT_ITEM}" ]]; then
#   echo "Parameter -i is  mandatory, plase check your script call"
#   exit_error
# fi

# main "${INPUT_ITEM}" "${INPUT_STATUS}"
main