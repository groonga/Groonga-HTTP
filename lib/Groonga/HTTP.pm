package Groonga::HTTP;
use strict;
use warnings;

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
