use Test2::V0;

BEGIN { push @INC, '/Groonga-HTTP/lib' }
use Groonga::HTTP;

# No arguments
{
  my $groonga = Groonga::HTTP->new;

  my $status = $groonga->status();

  is(
    $status,
    {
      alloc_count => E(),
      starttime => E(),
      start_time => E(),
      uptime => E(),
      version => E(),
      n_queries => E(),
      cache_hit_rate => E(),
      command_version => 1,
      default_command_version => 1,
      max_command_version => 3,
      n_jobs => E(),
      features => E(),
      apache_arrow => E
    },
    "status returns correct responses"
  );
}

# Specify arguments
{
  my $groonga = Groonga::HTTP->new(host => 'localhost', port => 10041);

  my $status = $groonga->status();

  is(
    $status,
    {
      alloc_count => E(),
      starttime => E(),
      start_time => E(),
      uptime => E(),
      version => E(),
      n_queries => E(),
      cache_hit_rate => E(),
      command_version => 1,
      default_command_version => 1,
      max_command_version => 3,
      n_jobs => E(),
      features => E(),
      apache_arrow => E
    },
    "status returns correct responses"
  );
}

done_testing;
