package Groonga::HTTP;

use LWP::UserAgent;
use JSON 'decode_json';

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
    my $query = _make_query({command => 'status'});
    my $http_response = _send_to_query($query);

    if ($http_response->code == 200) {
        my $command_response_raw = $http_response->content;
        my $command_response = decode_json($command_response_raw);
        my $groonga_reposnse_code = _get_groonga_response_code($command_response);
        if ($groonga_reposnse_code == 0) {
            return $command_response;
        } else {
            return $groonga_reposnse_code;
        }
    } else {
        return $http_response->code;
    }
}

sub _make_query {
    my %args = @_;
    my $command = '';

    given ($args{'command'}) {
        when ('status') { $command = 'status'; }
    }
    return "http://${host}:${port}/d/${command}";
}

sub _send_to_query {
    my $query = shift;
    my $user_agent = LWP::UserAgent->new;
    return $user_agent->get($query);
}

1;
