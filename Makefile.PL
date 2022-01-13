use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Groonga::HTTP',
    AUTHOR              => 'Horimoto Yasuhiro <horimoto@clear-code.com>',
    VERSION_FROM        => 'lib/Groonga/HTTP.pm',
    ABSTRACT_FROM       => 'lib/Groonga/HTTP.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Groonga-HTTP-*' },
);
