package Groonga::Commands::Select;

use strict;
use warnings;

my $groonga_http_client = undef;
my $command_args = "";
my $n_hits = undef;
my @records;
my $use_drilldown = 0;

sub new {
    my ($class, %args) = @_;
    my $self = {%args};

    $groonga_http_client = $self->{client};
    $command_args = _parse_arguments($self);

    return bless $self, $class;
}

sub _parse_arguments {
    my $args = shift;

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
    if (exists($args->{'synonym'})) {
        $parsed_arguments .= '&';
        $parsed_arguments .= "query_expander=" . $args->{'synonym'};
    }
    if (exists($args->{'drilldown'})) {
        $use_drilldown = 1;
        $parsed_arguments .= '&';
        $parsed_arguments .= "drilldown=" . $args->{'drilldown'};
    }

    return $parsed_arguments;
}

sub _parse_result {
    my $result = shift;
    my $i = 0;

    if ($use_drilldown) {
        $i += 1;
        $use_drilldown = 0;
    }

    my $n_hits = $result->[$i][0][0];
    my @records;

    my $j = 0;
    for ($j = 2; $j < ($n_hits+2); $j++) {
        if (exists($result->[$i][$j])) {
            push(@records, $result->[$i][$j]);
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
