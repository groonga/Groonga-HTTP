package Groonga::HTTP;

use LWP::UserAgent;
use Carp 'croak';

use Groonga::ResultSet;

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
    my $query = _make_query(
        command => 'status',
        command_args => {}
    );
    my $command_response = undef;

    eval {
        $command_response = _send_to_query($query);
    };
    if (my $request_error = $@) {
        croak $request_error;
    }
    return $command_response;
}

}

sub _make_query {
    my %args = @_;
    my $command_name = $args{'command'};
    my $command_args = $args{'command_args'};
    my $command = '';

    # TODO validation
    if     ($command_name eq 'status') { $command = $command_name; }
    return "http://${host}:${port}/d/${command}";
}

sub _send_to_query {
    my $query = shift;
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
