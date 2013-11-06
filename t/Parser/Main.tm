#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use Cwd 'abs_path';
use File::Path qw(make_path remove_tree);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::GFFValidator::Parser::Main');
}

my $cwd = getcwd();

# Create a parser object with a test GFF3 file
ok(
  (my $gff_parser = Bio::GFFValidator::Parser::Main->new(
   gff_file => 't/data/sample.gff3',
   )),
   'Create overall parser main object');
   
# Run the parser
ok($gff_parser->parse, 'Run the parser');

# Check the number of features created
is(3,scalar @{$gff_parser->get_features}, "Number of features should be 3");

# Check the number of gene models created

done_testing();