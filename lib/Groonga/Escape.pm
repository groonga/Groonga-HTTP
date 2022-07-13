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

package Groonga::Escape;

use strict;
use warnings;

use Carp 'croak';

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    return bless $self, $class;
}


sub _escape_value {
    my $escape = '\\';
    my ($raw_query, $escape_targets) = @_;
    unless($raw_query) {
        croak "Invalid arguments: ${raw_query}";
    }

    my $escaped_query = "";
    foreach $ch (split //, $raw_query) {
        foreach $escape_target (@$escape_targets) {
            if ($ch eq $escape_target) {
                $ch =~ s/$ch/$escape$ch/g;
                last;
            }
        }
        $escaped_query .= $ch;
    }

    return $escaped_query;
}

sub escape_filter_value {#
#grn_expr_syntax_escape
    return "";
}

sub escape_query_value {
    my $raw_query = shift;
    my @escape_targets = (
        '+',    #GRN_QUERY_AND
        '-',    #GRN_QUERY_AND_NOT,
        '>',    #GRN_QUERY_ADJ_INC,
        '<',    #GRN_QUERY_ADJ_DEC,
        '~',    #GRN_QUERY_ADJ_NEG,
        '*',    #GRN_QUERY_PREFIX,
        '(',    #GRN_QUERY_PARENL,
        ')',    #GRN_QUERY_PARENR,
        '"',    #GRN_QUERY_QUOTEL,
        '\\',   #GRN_QUERY_ESCAPE,
        ':',    #GRN_QUERY_COLUMN,
        '\0'
    );

    return _escape_value($raw_query, \@escape_targets);
}

1;
