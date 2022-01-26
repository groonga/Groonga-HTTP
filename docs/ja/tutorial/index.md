---
title: Tutorial
---

# チュートリアル

このドキュメントは、Groonga-HTTPの使い方を段階的に説明しています。まだ、Groonga-HTTPをインストールしていない場合は、このドキュメントを読む前にGroonga-HTTPをインストールしてください。

## ドリルダウン {#drilldown}

drilldown はカラムの値ごとにレコード数を数える機能を提供します。値ごとに別々のクエリーになるのではなく、1回のクエリーですべての値に対してレコード数を数えます。

Example:

```perl
use Groonga::HTTP;

my $groonga = Groonga::HTTP->new;

my @result = $groonga->select(
   table => 'Entries',
   output_columns => '_key,tag',
   drilldown => 'tag'
);

#Result
#[
#  [
#    "Hello",
#    1
#  ],
#  [
#    "Groonga",
#    2
#  ],
#  [
#    "Senna",
#    2
#  ]
#]
```

上記の例は以下のことを示しています。

  * ``tag`` の値が "Hello" であるレコードの数は1。
  * ``tag`` の値が "Groonga" であるレコードの数は2。
  * ``tag`` の値が "Senna" であるレコードの数は2。

## 結果のソート {#sort-of-result}

Groonga-HTTPは、検索結果を特定のカラムの値でソートできます。デフォルトの順序は昇順です。
"-"接頭辞によって、順序を逆にできます。

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
