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

package Groonga::Commands::CreateTable;

use Carp 'croak';

use strict;
use warnings;
use Data::Dumper;
use JSON;
my $groonga_http_client = undef;
my $command_args = "";
my @arguments = (
    'name',
    'flags',
    'key_type',
    'value_type',
    'default_tokenizer',
    'normalizer',
    'token_filters',
    'path'
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

    if (exists($args->{'table'})) {
        $parsed_arguments{'table'} = $args->{'table'};
    } else {
        croak 'Missing a require argument "table"';
    }
    if (exists($args->{'flags'})) {
        $parsed_arguments{'flags'} = $args->{'flags'};
    }
    if (exists($args->{'key_type'})) {
        $parsed_arguments{'key_type'} = $args->{'key_type'};
    }
    if (exists($args->{'value_type'})) {
        $parsed_arguments{'value_type'} = $args->{'value_type'};
    }
    if (exists($args->{'default_tokenizer'})) {
        $parsed_arguments{'default_tokenizer'} = $args->{'default_tokenizer'};
    }
    if (exists($args->{'normalizer'})) {
        $parsed_arguments{'normalizer'} = $args->{'normalizer'};
    }
    if (exists($args->{'token_filters'})) {
        $parsed_arguments{'token_filters'} = $args->{'token_filters'};
    }
    if (exists($args->{'path'})) {
        $parsed_arguments{'path'} = $args->{'path'};
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
    $result_set{'is_success'} = $result;

    return \%result_set;
}

sub execute {
    if (defined $groonga_http_client) {
        return _parse_result($groonga_http_client->send('table_create', $command_args));
    }
    return;
}

1;
