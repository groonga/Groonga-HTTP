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
  groonga-tokenizer-mecab \
  perl \
  perl-App-cpanminus

# Install Perl Modules for executing tests
cpanm Test2::V0

# Setting Groonga's database for executing tests
rm -rf db
mkdir db
groonga --protocol http -s -n db/db &

# Run test
cd Groonga-HTTP
prove
rm -rf db
