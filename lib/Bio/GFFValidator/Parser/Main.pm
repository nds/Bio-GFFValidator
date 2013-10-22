package Bio::GFFValidator::Parser::Main;
# ABSTRACT: 

=head1 SYNOPSIS

Parses a GFF file using Bio Perl and creates three arrays: one of feature objects, one of sequence region lines and one of gene models


=head1 SEE ALSO

=for :list
* L<Bio::GFFValidator::Parser::Gene>

=cut

use Moose;
use Bio::Tools::GFF;
use Bio::LocatableSeq;
use Bio::GFFValidator::GeneModel::Gene;

#use Bio::Root::Exception;
#use Error qw(:try); # Moose exports a keyword called with which clashes with Error's. This returns a prototype mismatch error
#use Try::Tiny;


has 'gff_file'        => ( is => 'ro', isa => 'Str',  required => 1 );
has 'features'		  => ( is => 'rw', isa => 'ArrayRef');
has 'seq_regions'	  => ( is => 'rw', isa => 'HashRef' );
has 'gene_models'	  => ( is => 'rw', isa => 'ArrayRef');


=head2 parse

  Arg [1]    : 
  Example    : my $gff_parser = Bio::GFFValidator::Parser::Main->new(gff_file => $self->gff_file);
	           $gff_parser->parse();
  Description: Parses a GFF file using Bio perl and creates an array of feature objects and an array of gene models
  Returntype : 

=cut


sub parse {

  my ($self) = @_;
  my @array_of_features;
  my %seq_regions;
  
  # After many attempts at using Try/Catch, we have resorted to eval for now. Eval has its own issues, so 
  # need to revisit this and think of possible alternative ways that allow us to catch specific exceptions.

  local $@;
  eval {
   		my $gff_parser = Bio::Tools::GFF->new(-file => $self->gff_file, -gff_version => 3);
   		
		# All feature lines
        while(my $feature = $gff_parser->next_feature()) {
         	push(@array_of_features, $feature);
         	
         	# Also construct the gene models
         	my $type = lc($feature->primary_tag());
         	my $current_gene;
         	my $current_prefix; 
         	my $prefix;   	
         	if( $type =~ m/gene/ ){ 
         		($prefix) = $feature->each_tag_value('ID');
         		if( (not defined $current_gene) or ($current_gene->prefix ne $prefix) ){
         			# Create a gene feature. Set it to be current gene and its prefix to be current prefix
         			bless $feature, 'Bio::GFFValidator::GeneModel::Gene';
         			$current_gene = $feature;
         			$current_prefix = $current_gene->prefix;

         		
         		}
         	
         	
         	
         	}elsif( $type =~ m/transcript/) {
         	
         	
         	
         	}elsif( $type =~ m/exon|utr|polypeptide/ ) { #Extend this list as other types related to gene models are discovered
         	
         	
         	
         	}
         	
        }
        
        # Process the header. Bio perl so far only returns seq region lines
        while(my $seq_region = $gff_parser->next_segment()){
        	$seq_regions{$seq_region->id} = [$seq_region->start, $seq_region->end];
        
        }     
        
        $gff_parser->close();
  };

  if($@){
  	# All parser errors will be handled by the appropriate handlers in GFFValidator.pm
  	$@->throw;
  }
  
  $self->seq_regions(\%seq_regions);
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

