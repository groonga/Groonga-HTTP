---
title: Tutorial
---

# Tutorial

This document describes how to use Groonga-HTTP step by step.
If you don't install Groonga-HTTP yet, [install][install] Groonga-HTTP before you read this document.

## Sort of result {#sort-of-result}

Groonga-HTTP can sort search results by a specific value of a column.
The default of the order is ascending order.
We can reverse the order by the prefix of "-".

Example:

```perl
use Groonga::HTTP;

my $groonga = Groonga::HTTP->new;

# Ascending order

my @result = $groonga->select(
  table => 'Site',
  columns => 'title',
  query => 'six OR seven',
  output_columns => '_id, title',
  sort_keys => 'id'
);

# Result
#    [
#      [
#        6,
#        'test test test test record six.'
#      ],
#      [
#        7,
#        'test test test record seven.'
#      ],
#    ],

# Descending order

my @result = $groonga->select(
  table => 'Site',
  columns => 'title',
  query => 'six OR seven',
  output_columns => '_id, title',
  sort_keys => '-id'
);

# Result
#    [
#      [
#        7,
#        'test test test record seven.'
#      ],
#      [
#        6,
#        'test test test test record six.'
#      ],
#    ],

```

[install]:../install/
