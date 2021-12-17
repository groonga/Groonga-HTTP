package Groonga::Commands::Status;

use Groonga::HTTP::Client;

use strict;
use warnings;

my $groonga_http_client = undef;

sub new {
    my ($class, %arg) = @_;
    my $self = {%arg};

    $groonga_http_client = $self->{client};

    return bless $self, $class;
}

sub _make_command {
    return "status";
}

sub execute {
    if (defined $groonga_http_client) {
        my $command = _make_command;
        return $groonga_http_client->send($command);
    }
    return;
}

1;
