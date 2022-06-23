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

BEGIN { push @INC, './lib' }
use Groonga::HTTP;

my $groonga = Groonga::HTTP->new(
  host => 'localhost',
  port => 10041
);

# Select no options
{
  my $result = $groonga->select(
     table => 'Site'
  );

  is(
    $result->{'n_hits'},
    9,
    "select returns correct number of hit"
  );

  my @records = ();
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_id'});
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'title'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        1,
        'http://example.org/',
        'This is test record 1!'
      ],
      [
        2,
        'http://example.net/',
        'test record 2.'
      ],
      [
        3,
        'http://example.com/',
        'test test record three.'
      ],
      [
        4,
        'http://example.net/afr',
        'test record four.'
      ],
      [
        5,
        'http://example.org/aba',
        'test test test record five.'
      ],
      [
        6,
        'http://example.com/rab',
        'test test test test record six.'
      ],
      [
        7,
        'http://example.net/atv',
        'test test test record seven.'
      ],
      [
        8,
        'http://example.org/gat',
        'test test record eight.'
      ],
      [
        9,
        'http://example.com/vdw',
        'test test record nine.'
      ],
    ],
    "select returns a correct records"
  );
}

# Select specify output
{
  my $result = $groonga->select(
     table => 'Site',
     output_columns => ["_id", "title"],
     limit => 3
  );

  is(
    $result->{'n_hits'},
    9,
    "select returns correct number of hit"
  );

  my @records = ();
  for (my $i = 0; $i < 3; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_id'});
    push (@record, $result->{'records'}[$i]->{'title'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        1,
        'This is test record 1!'
      ],
      [
        2,
        'test record 2.'
      ],
      [
        3,
        'test test record three.'
      ],
    ],
    "select returns a correct records"
  );
}

# Full text search
{
  my $result = $groonga->select(
     table => 'Site',
     columns => 'title',
     query => 'this',
     output_columns => ["_id", "title"]
  );

  is(
    $result->{'n_hits'},
    1,
    "select returns correct number of hit"
  );

  my @record;
  push (@record, $result->{'records'}[0]->{'_id'});
  push (@record, $result->{'records'}[0]->{'title'});

  is(
    \@record,
    [
      1,
      'This is test record 1!'
    ],
    "select returns a correct the record of _id=1"
  );
  @record = ();
}

# Specify sort_keys
{
  my $result = $groonga->select(
     table => 'Site',
     columns => 'title',
     query => 'six OR seven',
     output_columns => ["_id", "title"],
     sort_keys => '-_id'
  );

  is(
    $result->{'n_hits'},
    2,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_id'});
    push (@record, $result->{'records'}[$i]->{'title'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        7,
        'test test test record seven.'
      ],
      [
        6,
        'test test test test record six.'
      ],
    ],
    "select returns a correct records"
  );
}

# Synonym search
{
  my $result = $groonga->select(
     table => 'Entries',
     columns => 'content',
     query => 'mroonga',
     synonym => 'Thesaurus.synonym',
  );

  is(
    $result->{'n_hits'},
    2,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_id'});
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'content'});
    push (@record, $result->{'records'}[$i]->{'n_likes'});
    push (@record, $result->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        3,
        "Mroonga",
        "I also started to use Mroonga. It's also very fast! Really fast!",
        15,
        "Groonga"
      ],
      [
        5,
        "Good-bye Tritonn",
        "I also migrated all Tritonn system!",
        3,
        "Senna"
      ]
    ],
    "select returns a correct record"
  );
}

# Use query_expand
{
  my $result = $groonga->select(
     table => 'Entries',
     match_columns => 'content',
     query => 'groonga',
     query_expander => 'Thesaurus.synonym',
     output_columns => ["_key","content"]
  );

  is(
    $result->{'n_hits'},
    2,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'content'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "Groonga",
        "I started to use Groonga. It's very fast!",
      ],
      [
        "Good-bye Senna",
        "I migrated all Senna system!",
      ]
    ],
    "select returns a correct record"
  );
}

# Use dynamic column: missing "name" argument
{
  my @dynamic_columns = ();
  my %dynamic_column = (
     stage => 'initial',
     flags => 'COLUMN_SCALAR',
     type => 'Bool',
     value => 'n_likes >= 10'
  );
  push(@dynamic_columns, \%dynamic_column);

  like dies {
    my $result = $groonga->select(
       table => 'Entries',
       dynamic_columns => \@dynamic_columns,
       output_columns => ["_key","is_popular","n_likes"]
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"name\"";
}

# Use dynamic column: missing "stage" argument
{
  my @dynamic_columns = ();
  my %dynamic_column = (
     name => 'is_popular',
     flags => 'COLUMN_SCALAR',
     type => 'Bool',
     value => 'n_likes >= 10'
  );
  push(@dynamic_columns, \%dynamic_column);

  like dies {
    my $result = $groonga->select(
       table => 'Entries',
       dynamic_columns => \@dynamic_columns,
       output_columns => ["_key","is_popular","n_likes"]
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"stage\"";
}

# Use dynamic column: missing "type" argument
{
  my @dynamic_columns = ();
  my %dynamic_column = (
     name => 'is_popular',
     stage => 'initial',
     flags => 'COLUMN_SCALAR',
     value => 'n_likes >= 10'
  );
  push(@dynamic_columns, \%dynamic_column);

  like dies {
    my $result = $groonga->select(
       table => 'Entries',
       dynamic_columns => \@dynamic_columns,
       output_columns => ["_key","is_popular","n_likes"]
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"type\"";
}

# Use dynamic column: missing "value" argument
{
  my @dynamic_columns = ();
  my %dynamic_column = (
     name => 'is_popular',
     stage => 'initial',
     flags => 'COLUMN_SCALAR',
     type => 'Bool'
  );
  push(@dynamic_columns, \%dynamic_column);

  like dies {
    my $result = $groonga->select(
       table => 'Entries',
       dynamic_columns => \@dynamic_columns,
       output_columns => ["_key","is_popular","n_likes"]
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"value\"";
}

# Use dynamic column
{
  my @dynamic_columns = ();
  my %dynamic_column = (
     name => 'is_popular',
     stage => 'initial',
     flags => 'COLUMN_SCALAR',
     type => 'Bool',
     value => 'n_likes >= 10'
  );
  push(@dynamic_columns, \%dynamic_column);

  my $result = $groonga->select(
     table => 'Entries',
     dynamic_columns => \@dynamic_columns,
     filter => 'is_popular',
     output_columns => ["_key","is_popular","n_likes"]
  );

  is(
    $result->{'n_hits'},
    2,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'is_popular'});
    push (@record, $result->{'records'}[$i]->{'n_likes'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "Groonga",
        1,
        10
      ],
      [
        "Mroonga",
        1,
        15
      ]
    ],
    "select returns a correct record"
  );
}

# Use multiple dynamic column
{
  my @dynamic_columns = ();
  my %dynamic_column__key_snippet = (
      name => 'key_snippet',
      stage => 'output',
      flags => 'COLUMN_VECTOR',
      type => 'ShortText',
      value => 'snippet_html(_key)'
  );
  my %dynamic_column_content_snippet = (
      name => 'content_snippet',
      stage => 'output',
      flags => 'COLUMN_VECTOR',
      type => 'ShortText',
      value => 'snippet_html(content)'
  );
  push(@dynamic_columns, \%dynamic_column__key_snippet);
  push(@dynamic_columns, \%dynamic_column_content_snippet);

  my $result = $groonga->select(
     table => 'Entries',
     match_columns => '_key || content',
     query => 'Groonga',
     dynamic_columns => \@dynamic_columns,
     output_columns => ["key_snippet", "content_snippet"]
  );

  is(
    $result->{'n_hits'},
    1,
    "select returns correct number of hit"
  );

  my @record;
  push (@record, $result->{'records'}[0]->{'key_snippet'});
  push (@record, $result->{'records'}[0]->{'content_snippet'});

  is(
    \@record,
    [
      [
        "<span class=\"keyword\">Groonga</span>"
      ],
      [
        "I started to use <span class=\"keyword\">Groonga</span>. It's very fast!"
      ]
    ],
    "select returns a correct records"
  );
}

# Use match_columns
{
  my $result = $groonga->select(
     table => 'Entries',
     match_columns => 'content',
     query => 'fast',
     output_columns => ["_key","content","_score"]
  );

  is(
    $result->{'n_hits'},
    2,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'content'});
    push (@record, $result->{'records'}[$i]->{'_score'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "Groonga",
        "I started to use Groonga. It's very fast!",
        1,
      ],
      [
        "Mroonga",
        "I also started to use Mroonga. It's also very fast! Really fast!",
        2,
      ]
    ],
    "select returns a correct record"
  );
}

# Use match_columns with weight

{
  my $result = $groonga->select(
     table => 'Entries',
     match_columns => '_key || content * 2',
     query => 'groonga',
     output_columns => ["_key","content","_score"]
  );

  is(
    $result->{'n_hits'},
    1,
    "select returns correct number of hit"
  );

  my @record;
  push (@record, $result->{'records'}[0]->{'_key'});
  push (@record, $result->{'records'}[0]->{'content'});
  push (@record, $result->{'records'}[0]->{'_score'});

  is(
    \@record,
    [
      "Groonga",
      "I started to use Groonga. It's very fast!",
      3,
    ],
    "select returns a correct record"
  );
}

# Use multiple target columns in match_columns
{
  my $result = $groonga->select(
     table => 'Entries',
     match_columns => 'content || n_likes || tag',
     query => 'groonga',
     output_columns => ["_key","content"]
  );

  is(
    $result->{'n_hits'},
    1,
    "select returns correct number of hit"
  );

  my @record;
  push (@record, $result->{'records'}[0]->{'_key'});
  push (@record, $result->{'records'}[0]->{'content'});

  is(
    \@record,
    [
      "Groonga",
      "I started to use Groonga. It's very fast!",
    ],
    "select returns a correct record"
  );
}

# Drilldown
{
  my $result = $groonga->select(
     table => 'Entries',
     output_columns => ["_key","tag"],
     drilldown => 'tag'
  );

  is(
    $result->{'n_hits_drilldown'},
    3,
    "select returns correct number of hit (drilldown)"
  );

  my @drilldown_result_records;
  for (my $i = 0; $i < $result->{'n_hits_drilldown'}; $i++) {
    my @record = ();
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__key'});
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__nsubrecs'});
    $drilldown_result_records[0][$i] = \@record;
  }

  is(
    $drilldown_result_records[0],
    [
      [
        "Hello",
        1
      ],
      [
        "Groonga",
        2
      ],
      [
        "Senna",
        2
      ]
    ],
    "select returns a correct record (drilldown)"
  );

  is(
    $result->{'n_hits'},
    5,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "The first post!",
        "Hello"
      ],
      [
        "Groonga",
        "Groonga"
      ],
      [
        "Mroonga",
        "Groonga"
      ],
      [
        "Good-bye Senna",
        "Senna"
      ],
      [
        "Good-bye Tritonn",
        "Senna"
      ],
    ],
    "select returns correct records"
  );
}

# Drilldown sort
{
  my $result = $groonga->select(
     table => 'Entries',
     output_columns => ["_key","tag"],
     drilldown => 'tag',
     drilldown_sort_keys => '-_nsubrecs'
  );

  is(
    $result->{'n_hits_drilldown'},
    3,
    "select returns correct number of hit (drilldown)"
  );

  my @drilldown_result_records;
  for (my $i = 0; $i < $result->{'n_hits_drilldown'}; $i++) {
    my @record = ();
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__key'});
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__nsubrecs'});
    $drilldown_result_records[0][$i] = \@record;
  }

  is(
    $drilldown_result_records[0],
    [
      [
        "Groonga",
        2
      ],
      [
        "Senna",
        2
      ],
      [
        "Hello",
        1
      ]
    ],
    "select returns a correct record (drilldown)"
  );

  is(
    $result->{'n_hits'},
    5,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "The first post!",
        "Hello"
      ],
      [
        "Groonga",
        "Groonga"
      ],
      [
        "Mroonga",
        "Groonga"
      ],
      [
        "Good-bye Senna",
        "Senna"
      ],
      [
        "Good-bye Tritonn",
        "Senna"
      ],
    ],
    "select returns correct records"
  );
}

# Filter of the result of drilldown
{
  my $result = $groonga->select(
     table => 'Entries',
     output_columns => ["_key","tag"],
     drilldown => 'tag',
     drilldown_filter => '_nsubrecs > 1'
  );

  is(
    $result->{'n_hits_drilldown'},
    2,
    "select returns correct number of hit (drilldown)"
  );

  my @drilldown_result_records;
  for (my $i = 0; $i < $result->{'n_hits_drilldown'}; $i++) {
    my @record = ();
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__key'});
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__nsubrecs'});
    $drilldown_result_records[0][$i] = \@record;
  }

  is(
    $drilldown_result_records[0],
    [
      [
        "Groonga",
        2
      ],
      [
        "Senna",
        2
      ]
    ],
    "select returns a correct record (drilldown)"
  );

  is(
    $result->{'n_hits'},
    5,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "The first post!",
        "Hello"
      ],
      [
        "Groonga",
        "Groonga"
      ],
      [
        "Mroonga",
        "Groonga"
      ],
      [
        "Good-bye Senna",
        "Senna"
      ],
      [
        "Good-bye Tritonn",
        "Senna"
      ],
    ],
    "select returns correct records"
  );
}

# Specify output columns of the result of drilldown
{
  my $result = $groonga->select(
     table => 'Entries',
     output_columns => ["_key","tag"],
     drilldown => 'tag',
     drilldown_output_columns => '_key'
  );

  is(
    $result->{'n_hits_drilldown'},
    3,
    "select returns correct number of hit (drilldown)"
  );

  my @drilldown_result_records;
  for (my $i = 0; $i < $result->{'n_hits_drilldown'}; $i++) {
    my @record = ();
    push (@record, $result->{'drilldown_result_records'}[$i]->{'drilldown__key'});
    $drilldown_result_records[0][$i] = \@record;
  }

  is(
    $drilldown_result_records[0],
    [
      [
        "Hello"
      ],
      [
        "Groonga"
      ],
      [
        "Senna"
      ]
    ],
    "select returns a correct record (drilldown)"
  );

  is(
    $result->{'n_hits'},
    5,
    "select returns correct number of hit"
  );

  my @records;
  for (my $i = 0; $i < $result->{'n_hits'}; $i++) {
    my @record = ();
    push (@record, $result->{'records'}[$i]->{'_key'});
    push (@record, $result->{'records'}[$i]->{'tag'});
    $records[0][$i] = \@record;
  }

  is(
    $records[0],
    [
      [
        "The first post!",
        "Hello"
      ],
      [
        "Groonga",
        "Groonga"
      ],
      [
        "Mroonga",
        "Groonga"
      ],
      [
        "Good-bye Senna",
        "Senna"
      ],
      [
        "Good-bye Tritonn",
        "Senna"
      ],
    ],
    "select returns correct records"
  );
}

# Snippet
{
  my $result = $groonga->select(
     table => 'Site',
     match_columns => 'title',
     query => 'This',
     output_columns => ["_id", "snippet_html(title)"],
     limit => 3
  );

  is(
    $result->{'n_hits'},
    1,
    "select returns correct number of hit"
  );

  my @record;
  push (@record, $result->{'records'}[0]->{'_id'});
  push (@record, $result->{'records'}[0]->{'snippet_html'});

  is(
    \@record,
    [
      1,
      [
        "<span class=\"keyword\">This</span> is test record 1!"
      ]
    ],
    "select returns a correct records"
  );
}

done_testing();
