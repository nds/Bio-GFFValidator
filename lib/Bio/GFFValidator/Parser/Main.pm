package Bio::GFFValidator::Parser::Main;
# ABSTRACT: 

=head1 SYNOPSIS

Parses a GFF file using Bio Perl and creates two arrays: one of feature objects and one of gene models

=head1 SEE ALSO

=for :list
* L<Bio::GFFValidator::Parser::Gene>

=cut

use Moose;
use Bio::Tools::GFF;

#use Bio::Root::Exception;
#use Error qw(:try); # Moose exports a keyword called with which clashes with Error's. This returns a prototype mismatch error
#use Try::Tiny;


has 'gff_file'        => ( is => 'ro', isa => 'Str',  required => 1 );
has 'features'		  => ( is => 'rw', isa => 'ArrayRef');
has 'gene_models'	  => ( is => 'rw', isa => 'ArrayRef');

=head2 parse

  Arg [1]    : 
  Example    : my $gff_parser = Bio::GFFValidator::Parser::Main->new(gff_file => $self->gff_file);
	           $gff_parser->parse();
  Description: Parses a GFF file using Bio perl and creates an array of feature objects and an array of gene models
  Returntype : 

=cut


sub parse
{
  my ($self) = @_;
  my @array_of_features;
  
  # After many attempts at using Try/Catch, we have resorted to eval for now. Eval has its own issues, so 
  # need to revisit this and think of possible alternative ways that allow us to catch specific exceptions.

  local $@;
  eval {
   		my $gff_parser = Bio::Tools::GFF->new(-file => $self->gff_file, -gff_version => 3);

        while(my $feature = $gff_parser->next_feature()) {
         	push(@array_of_features, $feature);
        }
        
        $gff_parser->close();
  };

  if($@){
  	# All parser errors will be handled by the appropriate handlers in GFFValidator.pm
  	$@->throw;
  }
  

  $self->features(\@array_of_features);
  
}

sub get_features
{
	my ($self) = @_;
	return $self->features;
}


sub get_gene_models
{
	my ($self) = @_;
	return $self->gene_models;
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;

