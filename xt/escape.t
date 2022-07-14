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

BEGIN { push @INC, '/Groonga-HTTP/lib' }
use Groonga::HTTP;

# Use query escape
{
    my $groonga = Groonga::HTTP->new;
    my $escaped_query_value = $groonga->groonga_query_escape('a+B-c< >あいう~*()"\\\':');
    is(
      $escaped_query_value,
      'a\\+B\\-c\\< \\>あいう\\~\\*\\(\\)\\"\\\\\'\\:'
    );
}

# Invalid argument: specify undef
{
    my $groonga = Groonga::HTTP->new;

    like dies {
        my $escaped_query_value = $groonga->groonga_query_escape();
    }, qr/Invalid arguments: /, "Occures exception. Because missing required argument";
}

# Invalid argument: specify ''
{
    my $groonga = Groonga::HTTP->new;

    like dies {
        my $escaped_query_value = $groonga->groonga_query_escape('');
    }, qr/Invalid arguments: /, "Occures exception. Because missing required argument";
}

# Invalid argument: specify ''
{
    my $groonga = Groonga::HTTP->new;

    like dies {
        my $escaped_query_value = $groonga->groonga_query_escape('');
    }, qr/Invalid arguments: /, "Occures exception. Because missing required argument";
}

# Invalid argument: specify ""
{
    my $groonga = Groonga::HTTP->new;

    like dies {
        my $escaped_query_value = $groonga->groonga_query_escape("");
    }, qr/Invalid arguments: /, "Occures exception. Because missing required argument";
}

done_testing;
