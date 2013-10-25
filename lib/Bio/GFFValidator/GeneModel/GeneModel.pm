package Bio::GFFValidator::GeneModel::GeneModel;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array of feature objects, this will return a gene model. It also collects information that will be later used to generate error messages
(for instance, a list of features whose boundaries are not within the parent feature). It was considered more efficient to do this rather than
parse the gene model several times.

=method 


=cut

use Moose;

use Bio::GFFValidator::GeneModel::Gene;
use Bio::GFFValidator::GeneModel::Transcript;
use Bio::GFFValidator::GeneModel::Exon;
use Bio::GFFValidator::GeneModel::Polypeptide;
use Bio::GFFValidator::GeneModel::UTR;


has 'features'		    => ( is => 'ro', isa => 'ArrayRef', required => 1);
has 'prefix'			=> ( is => 'ro', isa => 'Str', required => 1);
has 'gene'	            => ( is => 'rw', isa => 'Bio::GFFValidator::GeneModel::Gene'); #We treat the gene as being the top of the model - everything else hangs off of it
has 'dangling_features' => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } ); # A list of features that, although having the same prefix, cannot be attached to the gene model
has 'dangling_features' => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );
has 'overhanging_features' => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );
has 'strands'			=> ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );

sub build {
	  my ($self) = @_;
	  my $gene;
	  my @transcripts;
	  my @exons;
	  my @polypeptides;
	  my @utrs;
	  
	  for my $feature (@{$self->features}){
	  		my $tag = lc($feature->primary_tag);
	  		
	  		#TODO: Improve this code to reduce repetition
	  		
	  		if($tag =~ /gene/){
	  			# Check that only one gene is present
	  			$gene = Bio::GFFValidator::GeneModel::Gene->new( name=>($self->_get_name($feature)),
	  															 start=>$feature->start,
	  															 end=>$feature->end,
	  															 strand=>$feature->strand);
	  		}elsif($tag =~ /mrna/){ # All other types of rna should also be here
	  			my $transcript_feature = Bio::GFFValidator::GeneModel::Transcript->new( name=>($self->_get_name($feature)),
	  															 				start=>$feature->start,
	  															 				end=>$feature->end,
	  															 				strand=>$feature->strand, 
	  															 				parent=>($self->_get_parent($feature)) );
	  			push(@transcripts, $transcript_feature);
	  		
	  		}elsif($tag =~ /cds/){
	  			my $exon_feature = Bio::GFFValidator::GeneModel::Exon->new( name=>($self->_get_name($feature)),
	  															 	start=>$feature->start,
	  															 	end=>$feature->end,
	  															 	strand=>$feature->strand,
	  															 	phase=>$feature->frame, 
	  															 	parent=>($self->_get_parent($feature)) );
	  			push(@exons, $exon_feature);
	  		
	  		}elsif($tag =~ /polypeptide/){
	  			my $polypeptide_feature = Bio::GFFValidator::GeneModel::Polypeptide->new( name=>($self->_get_name($feature)),
	  															 				  start=>$feature->start,
	  															 				  end=>$feature->end,
	  															 				  strand=>$feature->strand,
	  															 				  parent=>($self->_get_parent($feature)) );
	  			push(@polypeptides, $polypeptide_feature);
	  		
	  		
	  		}elsif($tag =~ /utr/){
	  			my $utr_feature = Bio::GFFValidator::GeneModel::UTR->new( name=>($self->_get_name($feature)),
	  															 				  start=>$feature->start,
	  															 				  end=>$feature->end,
	  															 				  strand=>$feature->strand,
	  															 				  parent=>($self->_get_parent($feature)) );
	  			push(@utrs, $utr_feature);
	  		}
	  	}
	  		
	  	# Could possibly do some error checking here like if they are all on the same strand, but for now we have refrained from doing so
	  	# for ease of maintainability. All gene model checks are called by the GFFValidator.pm module
	  		
	  	if(defined $gene){
	  		# For every transcript, attach its 'children'. When done, attach transcript to the gene
	  		for my $transcript (@transcripts){
	  			#Exons
	  			for my $exon (@exons) {
	  				if($exon->parent eq $transcript->name){
	  					$transcript->add_exon($exon);
	  					if($exon->start < $transcript->start or $exon->end > $transcript->end) {
	  						push(@{$self->overhanging_features},$exon->name);
	  					}
	  				}else{
	  					push(@{$self->dangling_features},$exon->name);
	  					print STDERR "Pushing $exon->name into dangling features \n";
	  				}	  				
	  			}
	  				
	  			#Polypeptides
	  			for my $polypeptide (@polypeptides) {
	  				if($polypeptide->parent eq $transcript->name){
	  					$transcript->add_polypeptide($polypeptide);
	  					if($polypeptide->start < $transcript->start or $polypeptide->end > $transcript->end) {
	  						push(@{$self->overhanging_features},$polypeptide->name);
	  					}
	  				}else{
	  					push(@{$self->dangling_features},$polypeptide->name);
	  					print STDERR "Pushing $polypeptide->name into dangling features \n";
	  				}	  				
	  			}
	  			
	  			#UTRs
	  			for my $utr (@utrs) {
	  				if($utr->parent eq $transcript->name){
	  					$transcript->add_utr($utr);
	  					if($utr->start < $transcript->start or $utr->end > $transcript->end) {
	  						push(@{$self->overhanging_features},$utr->name);
	  					}
	  				}else{
	  					push(@{$self->dangling_features},$utr->name);
	  					print STDERR "Pushing $utr->name into dangling features \n";
	  				}	  				
	  			}
	  				
	  			# Attach transcript
				if($transcript->parent eq $gene->name){
					$gene->add_transcript($transcript);
					if($transcript->start < $gene->start or $transcript->end > $gene->end) {
	  						push(@{$self->overhanging_features},$transcript->name);
	  				}
				}else{
					push(@{$self->dangling_features},$transcript->name);
					print STDERR "Pushing $transcript->name into dangling features \n";
				}
	  		}
	  		$self->gene($gene);
	  	}else{
	  		# No gene feature specified. Drop all the features that are meant to be part of this model into the dangling features list
	  		foreach (@{$self->features}){
	  			push(@{$self->dangling_features},$self->_get_name($_));
	  		}
	  	
	  	
	  	}
	

	return $self; 
	  
}

sub _get_name {
	# Get the name of the feature (i.e. the value of the ID column)
	my ($self, $feature) = @_;
	my ($ID) = $feature->each_tag_value('ID');
	return $ID;
}

sub _get_parent {
	# Get the parent of the feature
	my ($self, $feature) = @_;
	my $parent;
	if(lc($feature->primary_tag) eq "polypeptide"){
		($parent) = $feature->each_tag_value('Derives_from');
	}else{
		($parent) = $feature->each_tag_value('Parent');
	}
	 
	return $parent;
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;