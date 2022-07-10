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

package Groonga::HTTP::Client;

use LWP::UserAgent;
use Carp 'croak';

use Groonga::ResultSet;
use URI ();

use strict;
use warnings;

my $prefix = "";

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    my $host = $self->{host};
    my $port = $self->{port};

    $prefix = "http://${host}:${port}/d/";
    return bless $self, $class;
}

sub _uri_encode {
    my $command = $_[1];
    my $uri_encoded_query = URI->new($prefix . $command);

    if (defined $_[2]) {
        my $command_args = $_[2];
        $uri_encoded_query->query_form($command_args);
    }

    return $uri_encoded_query;
}

sub send {
    my $uri_encoded_query = _uri_encode(@_);

    my $user_agent = LWP::UserAgent->new;
    my $http_response = $user_agent->get($uri_encoded_query);
    if ($http_response->is_success) {
        my $groonga_response =
            Groonga::ResultSet->new(
                decoded_content => $http_response->decoded_content
            );
        if ($groonga_response->is_success) {
            return $groonga_response->content;
        } else {
            croak $groonga_response->content;
        }
    } else {
        croak $http_response->status_line;
    }
}

sub query_form {
    my $command = $_[1];
    my $uri = URI->new($prefix . $command);

    if (defined $_[2]) {
        my $args = $_[2];
        $uri->query_form($args);
    }

    return $uri
}

1;
