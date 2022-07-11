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

my $groonga = Groonga::HTTP->new(
  host => 'localhost',
  port => 10041
);

# Load data
{
  my @data = ();
  my %first_record = (
      _key => 'Load01',
      content => 'This is Load01 test!!!',
      n_likes => 3,
      tag => "Test"
  );
  push(@data, \%first_record);
  my %second_record = (
      _key => 'Load02',
      content => 'This is Load02 test!!!',
      n_likes => 2,
      tag => "Test"
  );
  push(@data, \%second_record);

  my $result = $groonga->load(
     table => 'Entries',
     values => \@data
  );

  is(
    $result->{'n_loaded_records'},
    2,
    "load returns correct number of loaded records"
  );

  my $search_results = $groonga->select(
     table => 'Entries'
  );

  is(
    $search_results->{'n_hits'},
    7,
    "select returns correct number of hit"
  );
  my @records;
  for (my $i = 0; $i < $search_results->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $search_results->{'records'}[$i]->{'_key'});
    push (@record, $search_results->{'records'}[$i]->{'content'});
    push (@record, $search_results->{'records'}[$i]->{'n_likes'});
    push (@record, $search_results->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }
  is(
    $records[0],
    [
      [
        "The first post!",
        "Welcome! This is my first post!",
        5,
        "Hello"
      ],
      [
        "Groonga",
        "I started to use Groonga. It's very fast!",
        10,
        "Groonga"
      ],
      [
        "Mroonga",
        "I also started to use Mroonga. It's also very fast! Really fast!",
        15,
        "Groonga"
      ],
      [
        "Good-bye Senna",
        "I migrated all Senna system!",
        3,
        "Senna"
      ],
      [
        "Good-bye Tritonn",
        "I also migrated all Tritonn system!",
        3,
        "Senna"
      ],
      [
        "Load01",
        "This is Load01 test!!!",
        3,
        "Test"
      ],
      [
        "Load02",
        "This is Load02 test!!!",
        2,
        "Test"
      ],
    ],
    "select returns correct records"
  );

  my $delete_result = $groonga->delete(
     table => 'Entries',
     key => 'Load01'
  );
  my $delete_result = $groonga->delete(
     table => 'Entries',
     key => 'Load02'
  );
}

done_testing();
