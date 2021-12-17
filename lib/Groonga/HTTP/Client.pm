package Groonga::HTTP::Client;

use LWP::UserAgent;
use Carp 'croak';
use Data::Dumper;

use Groonga::ResultSet;

use strict;
use warnings;

my $query = "";

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    my $host = $self->{host};
    my $port = $self->{port};

    $query = "http://${host}:${port}/d/";
    return bless $self, $class;
}

sub send {
    my $command = $_[1];
    $query = $query . $command;
    my $user_agent = LWP::UserAgent->new;

    my $http_response = $user_agent->get($query);
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

1;
