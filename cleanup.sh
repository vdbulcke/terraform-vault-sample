#!/bin/bash

echo "WARNING: this will remove the terraform state file"

echo -e "Press any key to continue"
read -n 1 -s -r -p ""

rm terraform.tfstate
rm terraform.tfstate.backup
rm .terraform.lock.hcl
rm .terraform -rf

