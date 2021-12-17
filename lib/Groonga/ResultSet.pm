package Groonga::ResultSet;

use JSON;

my $command_response_code = undef;
my @command_response_raw = ();
my $command_response = {};

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    if ($self->{decoded_content}) {
        my $json = JSON->new;

        @command_response_raw = $json->decode($self->{decoded_content});
        $command_response_code = $command_response_raw[0][0][0];
        $command_response = $command_response_raw[0][1];
    }

    return bless $self, $class;
}

sub is_success {
    return $command_response_code == 0;
}

sub content {
    return $command_response;
}

1;
