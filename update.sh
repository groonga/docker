#!/bin/bash

set -eu

if [ $# != 1 ]; then
  echo "Usage: $0 GROONGA_VERSION"
  echo " e.g.: $0 10.0.6"
  exit 1
fi

groonga_version=$1

if type gsed > /dev/null 2>&1; then
  SED=gsed
else
  SED=sed
fi

for docker_file in */Dockerfile; do
  ${SED} \
    -i'' \
    -r \
    -e "s/ GROONGA_VERSION=[0-9.]*/ GROONGA_VERSION=${groonga_version}/g" \
    ${docker_file}
  git add ${docker_file}
done

ruby "$(dirname "$0")/update-tag-list.rb" "$@"
git add README.md

message="Groonga ${groonga_version}"
git commit -m "${message}"

tag="${groonga_version}"
echo ${tag}
git tag -a -m "${message}" ${tag}
