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

my $groonga = Groonga::HTTP->new(
  host => 'localhost',
  port => 10041
);

# Select no options
{
  my @result = $groonga->select(
     table => 'Site'
  );

  is(
    $result[0],
    9,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
      ]
    ],
    "select returns a correct record"
  );
}

# Select specify output
{
  my @result = $groonga->select(
     table => 'Site',
     output_columns => '_id, title'
  );

  is(
    $result[0],
    9,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
      [
        4,
        'test record four.'
      ],
      [
        5,
        'test test test record five.'
      ],
      [
        6,
        'test test test test record six.'
      ],
      [
        7,
        'test test test record seven.'
      ],
      [
        8,
        'test test record eight.'
      ],
      [
        9,
        'test test record nine.'
      ]
    ],
    "select returns a correct record"
  );
}

# Full text search
{
  my @result = $groonga->select(
     table => 'Site',
     columns => 'title',
     query => 'this',
     output_columns => '_id, title'
  );

  is(
    $result[0],
    1,
    "select returns correct number of hit"
  );

  is(
    $result[1],
    [
      [
        1,
        'This is test record 1!'
      ]
    ],
    "select returns a correct record"
  );
}

# Specify sort_keys
{
  my @result = $groonga->select(
     table => 'Site',
     columns => 'title',
     query => 'six OR seven',
     output_columns => '_id, title',
     sort_keys => '-_id'
  );

  is(
    $result[0],
    2,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
    "select returns a correct record"
  );
}

# Specify limit
{
  my @result = $groonga->select(
     table => 'Site',
     columns => 'title',
     query => 'six OR seven',
     output_columns => '_id, title',
     sort_keys => '-_id',
     limit => '1'
  );

  is(
    $result[0],
    2,
    "select returns correct number of hit"
  );

  is(
    $result[1],
    [
      [
        7,
        'test test test record seven.'
      ]
    ],
    "select returns a correct record"
  );
}

# Synonym search
{
  my @result = $groonga->select(
     table => 'Entries',
     columns => 'content',
     query => 'mroonga',
     synonym => 'Thesaurus.synonym',
  );

  is(
    $result[0],
    2,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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

# Drilldown
{
  my @result = $groonga->select(
     table => 'Entries',
     output_columns => '_key,tag',
     drilldown => 'tag'
  );

  is(
    $result[0],
    3,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
    "select returns a correct record"
  );
}

# Filter of the result of drilldown
{
  my @result = $groonga->select(
     table => 'Entries',
     output_columns => '_key,tag',
     drilldown => 'tag',
     drilldown_filter => '_nsubrecs > 1'
  );

  is(
    $result[0],
    2,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
    "select returns a correct record"
  );
}

# Specify output columns of the result of drilldown
{
  my @result = $groonga->select(
     table => 'Entries',
     output_columns => '_key,tag',
     drilldown => 'tag',
     drilldown_output_columns => '_key'
  );

  is(
    $result[0],
    3,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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
    "select returns a correct record"
  );
}

# Use dynamic column: missing "name" argument
{
  like dies {
    my @result = $groonga->select(
       table => 'Entries',
       dynamic_columns => { stage => 'initial',
                            flags => 'COLUMN_SCALAR',
                            type => 'Bool',
                            value => 'n_likes >= 10'
                          },
       output_columns => '_key,is_popular,n_likes'
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"name\"";
}

# Use dynamic column: missing "stage" argument
{
  like dies {
    my @result = $groonga->select(
       table => 'Entries',
       dynamic_columns => { name => 'is_popular',
                            flags => 'COLUMN_SCALAR',
                            type => 'Bool',
                            value => 'n_likes >= 10'
                          },
       output_columns => '_key,is_popular,n_likes'
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"stage\"";
}

# Use dynamic column: missing "type" argument
{
  like dies {
    my @result = $groonga->select(
       table => 'Entries',
       dynamic_columns => { name => 'is_popular',
                            stage => 'initial',
                            flags => 'COLUMN_SCALAR',
                            value => 'n_likes >= 10'
                          },
       output_columns => '_key,is_popular,n_likes'
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"type\"";
}

# Use dynamic column: missing "value" argument
{
  like dies {
    my @result = $groonga->select(
       table => 'Entries',
       dynamic_columns => { name => 'is_popular',
                            stage => 'initial',
                            flags => 'COLUMN_SCALAR',
                            type => 'Bool',
                          },
       output_columns => '_key,is_popular,n_likes'
    );
  }, qr/Missing required argument/, "Occures exception. Because missing required argument \"value\"";
}


# Use dynamic column
{
  my @result = $groonga->select(
     table => 'Entries',
     dynamic_columns => { name => 'is_popular',
                          stage => 'initial',
                          flags => 'COLUMN_SCALAR',
                          type => 'Bool',
                          value => 'n_likes >= 10'
                        },
     filter => 'is_popular',
     output_columns => '_key,is_popular,n_likes'
  );

  is(
    $result[0],
    2,
    "select returns correct number of hit"
  );

  is(
    $result[1],
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

done_testing();
