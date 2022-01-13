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

package Groonga::HTTP;

use LWP::UserAgent;

use Groonga::ResultSet;
use Groonga::HTTP::Client;
use Groonga::Commands::Status;
use Groonga::Commands::Select;

use strict;
use warnings;

my $host = '127.0.0.1';
my $port = 10041;
my $groonga_http_client = undef;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    if ($self->{host}) {
        $host = $self->{host};
    }
    if ($self->{port}) {
        $port = $self->{port};
    }

    $groonga_http_client =
        Groonga::HTTP::Client->new(host => $host, port => $port);
    return bless $self, $class;
}

sub status {
    my $status =
        Groonga::Commands::Status->new(client => $groonga_http_client);
    return $status->execute;
}

sub select {
    my ($client, %args) = @_;
    my $select =
        Groonga::Commands::Select->new(
            client => $groonga_http_client,
            %args
        );
    return $select->execute;
}

1;
