#!/usr/bin/env bash

# source "${REPO_ROOT}/bootstrap/config.sh"
source "../../bootstrap/config.sh"

terraform init
terraform destroy
