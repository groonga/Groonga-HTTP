package Groonga::Commands::Select;

use strict;
use warnings;

use Data::Dumper;

my $groonga_http_client = undef;
my $command_args = "";
my $n_hits = undef;
my @records;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    $groonga_http_client = $self->{client};
    $command_args = _parse_arguments($self);

    return bless $self, $class;
}

sub _parse_arguments {
    my $args = shift;
    print Dumper($args->{'output_columns'});

    my $parsed_arguments = "";

    if (exists($args->{'table'})) {
        $parsed_arguments .= "table=" . $args->{'table'};
    }
    if (exists($args->{'output_columns'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "output_columns=" . $args->{'output_columns'};
    }
    if (exists($args->{'query'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "query=" . $args->{'query'};
    }
    if (exists($args->{'columns'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "match_columns=" . $args->{'columns'};
    }
    if (exists($args->{'sort_keys'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "sort_keys=" . $args->{'sort_keys'};
    }
    if (exists($args->{'limit'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "limit=" . $args->{'limit'};
    }

    return $parsed_arguments;
}

sub _parse_result {
    my $result = shift;
    my $n_hits = $result->[0][0][0];
    my @records;

    my $i = 0;
    for ($i = 2; $i < ($n_hits+2); $i++) {
        if (exists($result->[0][$i])) {
            push(@records, $result->[0][$i]);
        }
    }
    return ($n_hits, \@records);
}

sub _make_command {
    return 'select' . '?' . $command_args;
}

sub execute {
    if (defined $groonga_http_client) {
        my $command = _make_command;
        return _parse_result($groonga_http_client->send($command));
    }
    return;
}

1;
