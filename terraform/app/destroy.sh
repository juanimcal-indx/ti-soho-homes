#!/usr/bin/env bash

readonly REPO_ROOT=$(git rev-parse --show-toplevel)

source "${REPO_ROOT}/bootstrap/config.sh"

terraform init
terraform destroy
