#!/usr/bin/env perl
package  Bio::GFFValidator::Bin::GFFValidator;

# ABSTRACT: 
# PODNAME: gff_validator.pl
=head1 SYNOPSIS
  
Usage: gff_validator.pl [options]
	
		-f|gff_file        <gff file>
		-o|output_option   <output options 1: error report 2: summary 3: fix errors>
        -e|error_file	   <name of error file>
        -d|debug		   <debug>
        -h|help      	   <this message>
        
Takes in a gff file and validates it. Depending on the -o option, it can either print an error report (default), print a summary or fix the errors found (not implemented yet)

# Outputs an error file in the current working directory. The error file will be named using the GFF file's name by default, unless an alternative is specified

gff_validator.pl -f myfile.gff

   
=cut

BEGIN { unshift( @INC, '../lib' ) }

use Getopt::Long;
use Bio::GFFValidator::GFFValidator;

my ( $gff_file, $output_option, $error_file, $help );

GetOptions(
		'f|gff_file=s'          => \$gff_file,
		'o|output_option=i'     => \$output_option,
		'e|error_file=s'        => \$error_file,
    	'h|help'                => \$help,
);

 my $gff_validator_commandline_wrongfile = Bio::GFFValidator::CommandLine::GFF_Validator_Commandline->new(
   									gff_file =>  $gff_file,
   									output_option => $output_option,
   									error_file => $error_file,
   									help => $help,
);
