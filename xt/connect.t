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

use Test2::V0;

BEGIN { push @INC, '/Groonga-HTTP/lib' }
use Groonga::HTTP;

# No arguments
{
  my $groonga = Groonga::HTTP->new;

  my $status = $groonga->status();

  is(
    $status,
    {
      alloc_count => E(),
      starttime => E(),
      start_time => E(),
      uptime => E(),
      version => E(),
      n_queries => E(),
      cache_hit_rate => E(),
      command_version => 1,
      default_command_version => 1,
      max_command_version => 3,
      memory_map_size => E(),
      n_jobs => E(),
      features => E(),
      apache_arrow => E
    },
    "status returns correct responses"
  );
}

# Specify arguments
{
  my $groonga = Groonga::HTTP->new(host => 'localhost', port => 10041);

  my $status = $groonga->status();

  is(
    $status,
    {
      alloc_count => E(),
      starttime => E(),
      start_time => E(),
      uptime => E(),
      version => E(),
      n_queries => E(),
      cache_hit_rate => E(),
      command_version => 1,
      default_command_version => 1,
      max_command_version => 3,
      n_jobs => E(),
      features => E(),
      apache_arrow => E
    },
    "status returns correct responses"
  );
}

done_testing;
