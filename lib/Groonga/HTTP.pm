package Groonga::HTTP;

use LWP::UserAgent;
use JSON 'decode_json';
use Carp 'croak';

use strict;
use warnings;

my $host = '127.0.0.1';
my $port = 10041;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    if ($self->{host}) {
        $host = $self->{host};
    }
    if ($self->{port}) {
        $port = $self->{port};
    }
    return bless $self, $class;
}

sub status {
    my $query = _make_query(command => 'status');
    } else {
        return $http_response->code;
    }
}

sub _make_query {
    my %args = @_;
    my $command = $args{'command'};

    # TODO validation
    return "http://${host}:${port}/d/${command}";
}

sub _send_to_query {
    my $query = shift;
    my $user_agent = LWP::UserAgent->new;

    my $http_response = $user_agent->get($query);
    if ($http_response->is_success) {
        return Groonga::ResultSet->new(decoded_content => $http_response->decoded_content);
    } else {
        croak $http_response->status_line;
    }
}

1;
