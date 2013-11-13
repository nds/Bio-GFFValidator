package Bio::GFFValidator::Feature::Feature;
# ABSTRACT: 

=head1 SYNOPSIS

A Feature class to extract certain bits of information from the features returned by the Bio Perl parser

=method 


=cut

use Moose;
use Bio::SeqFeatureI;

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object

# Returns all the key-value pairs in the 9th column 
sub get_attributes_for_feature {
	my ($self) = @_;
 	my @tags = ($self->feature)->get_all_tags();
	# Creating a tag => value hash
 	my %attributes;
	for my $tag (@tags){
		my @values = ($self->feature)->get_tag_values($tag);
		$attributes{$tag} = [@values];

	}
	return %attributes;
}

# Returns the value of the ID tag 
sub get_feature_id {
	my ($self) = @_;
 	my @values = ($self->feature)->get_tag_values('ID');
	if((scalar @values) != 1){
		return "Can't locate ID";
	}else{
		return $values[0];
	}
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;