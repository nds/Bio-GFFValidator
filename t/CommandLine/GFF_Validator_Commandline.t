#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;


BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use Test::Exception;
    use_ok('Bio::GFFValidator::CommandLine::GFF_Validator_Commandline');
}

my $cwd = getcwd();

# Create a validator with no file
dies_ok {
  my $gff_validator_commandline_nofile = Bio::GFFValidator::CommandLine::GFF_Validator_Commandline->new() }									
  'Creating a validator with no file should die';

# Create a validator with a file that is not gff
dies_ok {
  my $gff_validator_commandline_wrongfile = Bio::GFFValidator::CommandLine::GFF_Validator_Commandline->new(
   									gff_file =>  getcwd().'/t/data/non_gff.zip',
   )}
  'Creating a validator object with a non gff file should die';

# Create a  validator with an option that is besides 1,2 or 3
dies_ok{
  my $gff_validator_commandline_wrongoption = Bio::GFFValidator::CommandLine::GFF_Validator_Commandline->new(
   									gff_file =>  getcwd().'/t/data/sample.gff3',
   									output_option => 4,
  )}
  'Creating a validator object with a wrong option should dies';
  
# Create a validator with a gff file
ok(
  my $gff_validator_commandline = Bio::GFFValidator::CommandLine::GFF_Validator_Commandline->new(
   									gff_file =>  getcwd().'/t/data/sample.gff3',
  ),
  'Creating a validator object ok');
  
ok(
  $gff_validator_commandline->run(),
  "Running the validator OK.");

done_testing();
