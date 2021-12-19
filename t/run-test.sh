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
  gcc \
  groonga \
  groonga-tokenizer-mecab \
  perl \
  perl-App-cpanminus

# Install Perl Modules for executing tests
cpanm \
    Test2::V0 \
    LWP::UserAgent \
    JSON

# Setting Groonga's database for executing tests

cd Groonga-HTTP
rm -rf db
mkdir db

cat t/fixture/*.grn > dump.grn
groonga --protocol http -s -n db/db < dump.grn &

# Run test
prove -v
rm -rf db
