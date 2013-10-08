#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use Cwd 'abs_path';
use File::Path qw(make_path remove_tree);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::GFFValidator::GFFValidator');
}

my $cwd = getcwd();

# Create a validator object with a test GFF3 file
ok(
  (my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   gff_file => 't/data/sample.gff3',
   )),
   'Create overall validator object');
   
# Run the validator
ok($gff_validator->run, 'Run the validator');

# Check the location and contents of error report

done_testing();