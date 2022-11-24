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

package Groonga::Commands::Delete;

use Carp 'croak';

use strict;
use warnings;
use Data::Dumper;
use JSON;
my $groonga_http_client = undef;
my $command_args = "";
my @arguments = (
    'tables',
    'dump_plugins',
    'dump_schema',
    'dump_records',
    'dump_indexes',
    'dump_configs',
    'sort_hash_table'
);

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    $groonga_http_client = $self->{client};
    $command_args = _parse_arguments($self);

    return bless $self, $class;
}

sub _is_valid_arguments {
    my $args = shift;

    while (my ($key, $value) = each %{$args}) {
        if ($key eq 'client') {
            next;
        }
        if (!(grep {$_ eq $key} @arguments)) {
            croak "Invalid arguments: ${key}";
        }
    }

    return 1; #true
}

sub _parse_arguments {
    my $args = shift;

    my %parsed_arguments = ();

    _is_valid_arguments($args);

    if (exists($args->{'tables'})) {
        $parsed_arguments{'tables'} = $args->{'tables'};
    }
    if (exists($args->{'dump_plugins'})) {
        $parsed_arguments{'dump_plugins'} = $args->{'dump_plugins'};
    }
    if (exists($args->{'dump_schema'})) {
        $parsed_arguments{'dump_schema'} = $args->{'dump_schema'};
    }
    if (exists($args->{'dump_records'})) {
        $parsed_arguments{'dump_records'} = $args->{'dump_records'};
    }
    if (exists($args->{'dump_indexes'})) {
        $parsed_arguments{'dump_indexes'} = $args->{'dump_indexes'};
    }
    if (exists($args->{'dump_configs'})) {
        $parsed_arguments{'dump_configs'} = $args->{'dump_configs'};
    }
    if (exists($args->{'sort_hash_table'})) {
        $parsed_arguments{'sort_hash_table'} = $args->{'sort_hash_table'};
    }

    return \%parsed_arguments;
}

sub _parse_result {
    my $result = shift;
    my %result_set = ();

    if ($result == JSON::PP::true) {
        $result = 1;
    } else {
        $result = 0;
    }
    print Dumper $result;
    $result_set{'is_success'} = $result;

    return \%result_set;
}

sub execute {
    if (defined $groonga_http_client) {
        return _parse_result($groonga_http_client->send('dump', $command_args));
    }
    return;
}

1;
