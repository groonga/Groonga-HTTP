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

use FFI::Platypus;
use FFI::CheckLib;

my $ffi = undef;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    $ffi = FFI::Platypus->new( api => 2);
    $ffi->lib(find_lib_or_die lib => 'groonga');

    #grn_rc grn_ctx_init(grn_ctx *ctx, int flags)
    $ffi->type('opaque' => 'grn_ctx');
    $ffi->attach('grn_ctx_init' => ['grn_ctx', 'int'] => 'sint32');

    #grn_rc
    #grn_expr_syntax_escape(grn_ctx *ctx, const char *string, int string_size,
    #                       const char *target_characters,
    #                       char escape_character,
    #                       grn_obj *escaped_string)
    $ffi->type('int' => 'character');
    $ffi->type('opaque' => 'grn_obj');
    $ffi->attach('grn_expr_syntax_escape' => [
                                               'grn_ctx',
                                               'string',
                                               'int',
                                               'string',
                                               'string',
                                               'character',
                                               'grn_obj'
                                             ] => 'sint32');
    #grn_rc
    #grn_expr_syntax_escape_query(grn_ctx *ctx, const char *query, int query_size,
    #                             grn_obj *escaped_query)
    $ffi->attach('grn_expr_syntax_escape_query' => [
                                                     'grn_ctx',
                                                     'string',
                                                     'int',
                                                     'grn_obj'
                                                   ] => 'sint32');

    return bless $self, $class;
}

sub escape_query_value {
#grn_expr_syntax_escape_query
    return "";
}

sub escape_filter_value {#
#grn_expr_syntax_escape
    return "";
}

1;
