#!/bin/bash
#
# Copyright (C) 2021-2022  Horimoto Yasuhiro <horimoto@clear-code.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -exu

os=$(cut -d: -f4 /etc/system-release-cpe)
major_version=$(cut -d: -f5 /etc/system-release-cpe | grep -o "^[0-9]")

case ${major_version} in
  7)
    DNF=yum
    ;;
  *)
    DNF="dnf"
    ;;
esac

sudo ${DNF} update -y
sudo ${DNF} --enablerepo=powertools install -y \
  gcc \
  git \
  perl \
  perl-App-cpanminus

# Install Perl Modules
sudo cpanm Groonga::HTTP

perl -e "use Groonga::HTTP"
