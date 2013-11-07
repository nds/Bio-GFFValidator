package Bio::GFFValidator::Feature::Feature;
# ABSTRACT: 

=head1 SYNOPSIS

A Feature class to manipulate the features returned by the Bio Perl parser

=method 


=cut

use Moose;

# use Bio::SeqFeature::Generic;

has 'feature'  			 => ( is => 'ro' , isa => 'Str', required => 1); # Feature object returned by Bio Perl parser

# sub get_attributes_for_feature {
# 	my ($self) = @_;
# # 	my @tags = ($self->feature)->get_all_tags();
# 	# Creating a tag => value hash
#  	my %attributes;
# 	for my $tag (@tags){
# 		print STDERR "$tag is tag \n";
# 		my @values = ($self->feature)->get_tag_values($tag);
# 		$attributes{$tag} = [@values];
# 
# 	}
# 	return %attributes;
# }


no Moose;
__PACKAGE__->meta->make_immutable;
1;