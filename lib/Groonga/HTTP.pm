package Groonga::HTTP;

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

1;
