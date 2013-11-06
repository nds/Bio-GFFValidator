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
use Bio::GFFValidator::GeneModel::GeneModel;

#use Bio::Root::Exception;
#use Error qw(:try); # Moose exports a keyword called with which clashes with Error's. This returns a prototype mismatch error
#use Try::Tiny;


has 'gff_file'        => ( is => 'ro', isa => 'Str',  required => 1 );
has 'features'		  => ( is => 'rw', isa => 'ArrayRef');
has 'seq_regions'	  => ( is => 'rw', isa => 'HashRef' );
has 'gene_models'	  => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );


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
  my $current_prefix = "";
  my @features_for_gene_model;
  my %gene_models;
  
  # After many attempts at using Try/Catch, we have resorted to eval for now. Eval has its own issues, so 
  # need to revisit this and think of possible alternative ways that allow us to catch specific exceptions.

  local $@;
  eval {
   		my $gff_parser = Bio::Tools::GFF->new(-file => $self->gff_file, -gff_version => 3);
   		
		# All feature lines
        while(my $feature = $gff_parser->next_feature()) {
         	push(@array_of_features, $feature);
         	
         	# Construct the gene models.
         	# We look ahead in the file and collect all the feature lines that have the same ID/prefix. When the prefix
         	# changes, we process all the features and try to create a gene model. We assume here that the features are
         	# ordered by location and hence the components of one gene model are clustered together in the file.
         	
         	my $type = lc($feature->primary_tag());
         	if( $type =~ m/gene|mrna|exon|cds|polypeptide|utr/ ){ # Extend this regular expression for other components of a gene/pseudogene model
         		my ($ID) = $feature->each_tag_value('ID');
				$ID =~ /([^.:]*)/;
 				my $prefix = $1;
 				
 				if(defined $prefix and $current_prefix ne $prefix){
					if($current_prefix ne ""){ #If not equal to "", then it means this is not the first line
# 						$gene_models{$current_prefix} = [@features_for_gene_model];
						my $gene_model = (Bio::GFFValidator::GeneModel::GeneModel->new(features => \@features_for_gene_model, prefix => $current_prefix))->build();
						push(@{$self->gene_models},$gene_model);
					}						
					# Reset values
					undef @features_for_gene_model; # Clear array and free up any memory it used to hold on to
					$current_prefix = $prefix;					
				}
				
				push(@features_for_gene_model, $feature);
   	
         	}
         	
        }
        
        # Gather the last gene model
#       $gene_models{$current_prefix} = [@features_for_gene_model];
		my $gene_model = (Bio::GFFValidator::GeneModel::GeneModel->new(features => \@features_for_gene_model, prefix => $current_prefix))->build();
		push(@{$self->gene_models},$gene_model);
        
        # Process the header. Bio perl so far only returns seq region lines. TODO: Investigate if comments and other directives can be extracted using Bio Perl
        while(my $seq_region = $gff_parser->next_segment()){
        	$seq_regions{$seq_region->id} = [$seq_region->start, $seq_region->end];
        
        }     
        
        $gff_parser->close();
  };

  if($@){
  	# All parser errors will be handled by the appropriate handlers in GFFValidator.pm
  	$@->throw;
  }
  
#   $self->gene_models(\%gene_models);
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

