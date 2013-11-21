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

# Here is a list of sample GFF files that we will be running the tests on
# All sample GFF files are in t/data
# All error files are in t/error_files and should be named with the corresponding gff file name with '.ERROR_REPORT.txt' at the end

my @data_files = (
	'multiple_transcript.gff',
);

for my $data_file (@data_files){ 
	# Create a validator object with the test GFF file
	ok(
  		(my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   			gff_file =>  getcwd().'/t/data/'.$data_file, 
   			mode	 => 'test',
   		)),
   'Create overall validator object');
   
	# Run the validator
	ok($gff_validator->run, 'Run the validator');

	# Check the location and existence of the error report
	is(
    	$gff_validator->error_report,
    	join ('/', getcwd(), $data_file.'.ERROR_REPORT.txt'),   
   	'Default error report name ok');
	ok(-e $gff_validator->error_report, 'Error report exists');

	# Check the contents of the error report
	files_eq($gff_validator->error_report, getcwd().'/t/error_files/'.$data_file.'.ERROR_REPORT.txt', "Error file contents OK");
	
}


done_testing();