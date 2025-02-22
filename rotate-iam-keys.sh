#!/bin/bash
# download util from here using brew tap fullscreen/tap or directly from https://github.com/Fullscreen/aws-rotate-key
# install into your user's crontab by `crontab -e` 
# then insert the following line into your crontab, adjusting the paths to your dirs:
# 01 12 * * * AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials ~/proj/devops/rotate-iam-keys/rotate-iam-keys.sh
# rotate aws IAM keys
# remember to define the full path to your $AWS_SHARED_CREDENTIALS_FILE

set -euo pipefail

echo "Running aws-rotate-key: $(date)"
# # check to see if aws-rotate-key exists on the system
# if which aws-rotate-key; then
#     echo ""
# else
# 	>&2 echo "Could not find the aws-rotate-key utility on this system"
# 	exit 2
# fi

if [[ -z "${AWS_SHARED_CREDENTIALS_FILE}" ]]; then
	>&2 echo "\$AWS_SHARED_CREDENTIALS_FILE not set"
	exit 3
fi

profiles=$(grep "^\[" "${AWS_SHARED_CREDENTIALS_FILE}" |sort -u | xargs | tr '\[' ' ' | tr '\]' ' ')

echo "Started all IAM key rotation $(date +%Y-%m-%d_%H-%M-%S)"

for profile in $profiles; do
	echo -e "\t Rotating IAM key for ${profile}"
	/usr/local/bin/aws-rotate-key --profile "${profile}" -y
done

echo "Finished all IAM key rotations $(date +%Y-%m-%d_%H-%M-%S)"