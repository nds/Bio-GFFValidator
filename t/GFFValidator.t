#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use Cwd 'abs_path';
use File::Path qw(make_path remove_tree);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use Test::File::Contents;
    use_ok('Bio::GFFValidator::GFFValidator');
}

my $cwd = getcwd();

# Create a validator object with a test GFF3 file
ok(
  (my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   gff_file => 't/data/sample_no_errors.gff3',
   )),
   'Create overall validator object');
   
# Run the validator
ok($gff_validator->run, 'Run the validator');

# Check the location of the error report
my $current_dir = getcwd();
is(
    $gff_validator->error_report_name,
    join ('/', $current_dir, 'ERROR_REPORT.txt'),   
   'Default error report name ok');
ok(-e $gff_validator->error_report_name, 'Error report exists');

# Check the contents of the error report
files_eq($gff_validator->error_report_name, $current_dir.'/t/data/sample_error_report.txt', "Error file contents OK");


done_testing();