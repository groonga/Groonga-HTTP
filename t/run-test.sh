#!/bin/bash

set -exu

os=$(cut -d: -f4 /etc/system-release-cpe)
major_version=$(cut -d: -f5 /etc/system-release-cpe | grep -o "^[0-9]")

case ${major_version} in
  7)
    DNF=yum
    ;;
  *)
    DNF="dnf --enablerepo=powertools"
    ;;
esac

# Install packages for executing tests
${DNF} install -y \
  https://packages.groonga.org/${os}/${major_version}/groonga-release-latest.noarch.rpm

${DNF} install -y \
  groonga \
  groonga-tokenizer-mecab

# Run test
rm -rf db
groonga --protocol http -s -n db/db

prove t
rm -rf db
