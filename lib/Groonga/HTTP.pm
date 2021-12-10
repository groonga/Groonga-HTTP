package Groonga::HTTP;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};
    return bless $self, $class;
}
