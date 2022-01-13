use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Groonga::HTTP',
    license             => 'artistic2',
    dist_author         => 'Horimoto Yasuhiro <horimoto@clear-code.com>',
    dist_version_from   => 'lib/Groonga/HTTP.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Groonga-HTTP-*' ],
);

$builder->create_build_script();
