if (!defined $ENV{DBI_DSN}) {
    print "1..0 # Skipped: Cannot run test unless DBI_DSN is defined.  See the README file.\n";
    exit 0;
}

use DBI;
use strict;

print "1..3\n";
my $n = 1;

my $pgsql;
eval {
    $pgsql = DBI->connect($ENV{DBI_DSN}, $ENV{DBI_USER}, $ENV{DBI_PASS},
                          { RaiseError => 0, PrintError => 0 })
        or die $DBI::errstr;
};
print 'not ' if $@;
print "ok $n\n"; $n++;


eval {
    $pgsql->do(q{DROP TABLE test});
};
$pgsql->{RaiseError} = 1;
eval {
    $pgsql->do(q{
        CREATE TABLE test (
            id int, name varchar, value varchar, score float,
            date timestamp without time zone default 'now()'
        )
    });
};
print "not " if $@;
print "ok $n\n"; $n++;

eval { $pgsql->disconnect };
print 'not ' if $@;
print "ok $n\n";

1;
