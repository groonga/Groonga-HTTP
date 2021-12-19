use Test2::V0;

BEGIN { push @INC, './lib' }
use Groonga::HTTP;
use Data::Dumper;

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


done_testing();
