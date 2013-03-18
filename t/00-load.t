#!perl -T
use 5.012;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

my ($dir,$tf,$sc);


#plan tests => 5;

BEGIN {
    use_ok( 'SysConf' ) || print "Bail out!\n";
}

diag( "Testing SysConf $SysConf::VERSION, Perl $], $^X" );

# create a set of test files
diag( "Creating temp file and directory:");
$dir    = File::Temp->newdir();
diag( "dir  = $dir ");
diag( "file = temp.conf");

diag(" initiating object construction:");
$sc     = SysConf->new();
ok( defined($sc) );
ok( $sc->debug(1) );

diag(" setting path and file name");
ok( $dir eq $sc->path($dir) );
ok( "temp.conf" eq $sc->file("temp.conf") );

diag(" create the file");
ok( $sc->attach  );

diag(" add key value pairs");
ok( $sc->update({a=>1,b=>2,c=>3}));

diag(" detach");
ok( $sc->detach );


diag(" attach to existing file");
ok( $sc->attach );


diag(" update key value pairs");
ok( $sc->update({a=>11,b=>22,c=>33}));

diag(" detach");
ok( $sc->detach );

diag(" attach to existing file");
ok( $sc->attach );


diag(" retrieve values ");
ok( $sc->retrieve('a') eq "11");
ok( $sc->retrieve('b') eq "22");
ok( $sc->retrieve('c') eq "33");

diag(" return undef for missing keys ");
my $x;
$x = $sc->retrieve('z');
ok( !defined($x) );

done_testing();
