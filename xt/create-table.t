# Copyright (C) 2022  Horimoto Yasuhiro <horimoto@clear-code.com>
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

BEGIN { push @INC, './lib' }
use Groonga::HTTP;

my $groonga = Groonga::HTTP->new();

# Create Hash Table
{
  my $create_table_result = $groonga->create_table(
     name => 'Site'
  );
  is(
    $create_table_result->{'is_success'},
    1,
    "successed create table."
  );

  my $dump_results = $groonga->dump(
     tables => 'Site'
  );
  is(
    $dump_results[0],
    "table_create Sites TABLE_HASH_KEY",
    "dump returns correct results and successed create table."
  );
}

done_testing();
