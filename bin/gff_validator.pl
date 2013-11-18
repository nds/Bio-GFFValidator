#!/usr/bin/env perl
package  Bio::GFFValidator::Bin::GFFValidator;
# ABSTRACT: 
# PODNAME: gff_validator
=head1 SYNOPSIS
  
Usage: gff_validator [options]
	
		-f|gff_file        <gff file>
		-o|output_option   <output options 1: error report 2: summary 3: fix errors>
        -e|error_file	   <name of error file>
        -d|debug		   <debug>
        -h|help      	   <this message>
        
Takes in a gff file and validates it. Depending on the -o option, it can either print an error report (default), print a summary or fix the errors found (not implemented yet)

# Outputs an error file in the current working directory. The error file will be named using the GFF file's name
gff_validator -f myfile.gff

   
=cut

BEGIN { unshift( @INC, '../lib' ) }
#use lib "/software/pathogen/internal/prod/lib";
use Moose;
use Getopt::Long;
use Cwd;
use Cwd 'abs_path';
use File::Path qw(make_path);
use File::Basename;

use Bio::GFFValidator::GFFValidator;

my ( $gff_file, $output_option, $error_file, $debug, $help );

GetOptions(
		'f|gff_file=s'          => \$gff_file,
		'o|output_option=i'     => \$output_option,
		'e|error_file=s'        => \$error_file,
    	'd|debug'               => \$debug,
    	'h|help'                => \$help,
);

# A gff file is essential
( defined($gff_file) && !$help )
  or die <<USAGE;
Usage: gff_validator [options]
	
		-f|gff_file        <gff file>
		-o|output_option   <output option (1 (default): error report 2: summary 3: fix errors)>
		-e|error_file	   <name of error file (default is gff_file_name.ERROR_REPORT in current working directory)>
		-d|debug		   <debug>
		-h|help      	   <this message>

Takes in a gff file and validates it. Depending on the -o option, it can either print an error report (default), print a summary or fix the errors found (not implemented yet)

# Outputs an error file in the current working directory. The error file will be named using the GFF file's name
gff_validator -f myfile.gff

USAGE

# Set defaults
 
$output_option ||= 1;
$error_file  = basename($gff_file).".ERROR_REPORT";
$debug           ||= 0;

my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   gff_file =>  $gff_file,
   error_report => getcwd()."/".$error_file,
   handler_option => $output_option,
   #debug => $debug,
)->run;
