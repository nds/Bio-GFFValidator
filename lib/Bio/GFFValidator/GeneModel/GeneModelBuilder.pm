package Bio::GFFValidator::GeneModel::GeneModelBuilder;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array of feature objects, this will return a gene model. It also does some checks 

=method 


=cut

use Moose;

use Bio::GFFValidator::GeneModel::Gene;
use Bio::GFFValidator::GeneModel::Transcript;
use Bio::GFFValidator::GeneModel::Exon;
use Bio::GFFValidator::GeneModel::Polypeptide;
use Bio::GFFValidator::GeneModel::UTR;


has 'features'		    => ( is => 'ro', isa => 'ArrayRef', required => 1);
has 'gene'	            => ( is => 'rw', isa => 'Bio::GFFValidator::GeneModel::Gene'); #We treat the gene as being the top of the model - everything else hangs off of it
has 'dangling_features' => ( is => 'ro', isa => 'ArrayRef'); # A list of features that, although having the same prefix, cannot be attached to the gene model


sub build {
	  my ($self) = @_;
	  my $gene;
	  my @transcripts;
	  my @exons;
	  my @polypeptides;
	  my @utrs;
	  
	  for my $feature (@{$self->features}){
	  		my $tag = lc($feature->primary_tag);\
	  		
	  		#TODO: Improve this code to reduce repetition
	  		
	  		if($tag =~ /gene/){
	  			$gene = Bio::GFFValidator::GeneModel::Gene->new( name=>($self->_get_name($feature)),
	  															 start=>$feature->start,
	  															 end=>$feature->end,
	  															 strand=>$feature->strand,
	  															 phase=>$feature->phase );
	  		}elsif($tag =~ /mrna/){ # All other types of rna should also be here
	  			my $transcript = Bio::GFFValidator::GeneModel::Transcript->new( name=>($self->_get_name($feature)),
	  															 				start=>$feature->start,
	  															 				end=>$feature->end,
	  															 				strand=>$feature->strand,
	  															 				phase=>$feature->phase 
	  															 				parent=>($self->_get_parent($feature)) );
	  			push(@transcripts, $transcript);
	  		
	  		}elsif($tag =~ /cds/){
	  			my $exon = Bio::GFFValidator::GeneModel::Exon->new( name=>($self->_get_name($feature)),
	  															 	start=>$feature->start,
	  															 	end=>$feature->end,
	  															 	strand=>$feature->strand,
	  															 	phase=>$feature->phase 
	  															 	parent=>($self->_get_parent($feature)) );
	  			push(@exons, $exon);
	  		
	  		}elsif($tag =~ /polypeptide/){
	  			my $polypeptide = Bio::GFFValidator::GeneModel::Polypeptide->new( name=>($self->_get_name($feature)),
	  															 				  start=>$feature->start,
	  															 				  end=>$feature->end,
	  															 				  strand=>$feature->strand,
	  															 				  phase=>$feature->phase 
	  															 				  parent=>($self->_get_parent($feature)) );
	  			push(@polypeptides, $polypeptide);
	  		
	  		
	  		}elsif($tag =~ /utr/){
	  			my $utr = Bio::GFFValidator::GeneModel::UTR->new( name=>($self->_get_name($feature)),
	  															 				  start=>$feature->start,
	  															 				  end=>$feature->end,
	  															 				  strand=>$feature->strand,
	  															 				  phase=>$feature->phase 
	  															 				  parent=>($self->_get_parent($feature)) );
	  			push(@utrs, $utr);
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
	  					}else{
	  						push(@{$self->dangling_features},$exon);
	  					}	  				
	  				}
	  				
	  				#Polypeptides
	  				for my $polypeptide (@polypeptides) {
	  					if($polypeptide->parent eq $transcript->name){
	  						$transcript->add_polypeptide($polypeptide);
	  					}else{
	  						push(@{$self->dangling_features},$polypeptide);
	  					}	  				
	  				}
	  			
	  				#UTRs
	  				for my $utr (@utrs) {
	  					if($utr->parent eq $transcript->name){
	  						$transcript->add_utr($utr);
	  					}else{
	  						push(@{$self->dangling_features},$polypeptide);
	  					}	  				
	  				}
	  				
	  				# Attach transcript
					if($transcript->parent eq $gene->name){
						$gene->add_transcript($transcript);
					}else{
						push(@{$self->dangling_features},$transcript);
					}
	  			}
	  		
	  		
	  		
	  		
	  		}
	  
	  
	  
	  
	  }
}

sub _get_name {
	# Get the name of the feature (i.e. the value of the ID column)
	my ($ID) = $feature->each_tag_value('ID');
	return $ID;
}

sub _get_parent {
	# Get the parent of the feature
	if(lc($feature->primary_tag) eq "polypeptide"){
		my ($parent) = $feature->each_tag_value('Derives_from');
	}else{
		my ($parent) = $feature->each_tag_value('Parent');
	}
	 
	return $parent;
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;