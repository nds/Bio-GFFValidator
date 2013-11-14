package Bio::GFFValidator::Errors::GeneModel::GeneModelErrors;
# ABSTRACT: 

=head1 SYNOPSIS

Perform some validation checks on the gene model. 

=method 


=cut

use Moose;

use Bio::SeqFeatureI;
use Bio::GFFValidator::GeneModel::GeneModel;

extends "Bio::GFFValidator::Errors::BaseError";

has 'gene_model'   	=> ( is => 'ro', isa => 'Bio::GFFValidator::GeneModel::GeneModel', required => 1 );

sub validate {
	
	# We do several gene model checks here. An alternative would be to have separated them out into classes. However, there are several checks that can be done together by parsing
	# the gene model just once and this was considered more efficient
	
	my ($self) = @_;
	my $error_message = ''; 
	
	
	# Gene model complete check. If there are any dangling features, we list them 
	if(@{$self->gene_model->dangling_features}){
		$error_message = $self->_concat_to_error_message($error_message, "The following features cannot be attached to a gene model: ".join(", ", @{$self->gene_model->dangling_features}));
	
	}
	
	# Are all the feature boundaries within their parent features?
	if(@{$self->gene_model->overhanging_features}){
		$error_message = $self->_concat_to_error_message($error_message, "The following features are outside the boundaries of the gene/transcript: ".join(", ", @{$self->gene_model->overhanging_features}));
	
	}
	
	# Are the features all on the same strand?
	my $number_of_features = ($self->gene_model)->number_of_features;
	if( (${$self->gene_model->strands}{"0"} != $number_of_features) and (${$self->gene_model->strands}{"1"} != $number_of_features) and (${$self->gene_model->strands}{"-1"} != $number_of_features)) {
		$error_message = $self->_concat_to_error_message($error_message, "All the features of this gene model are not on the same strand");
	}
	
	# Set the error message
	if($error_message){
		# We use the gene model prefix as the value for these errors (not the feature ID)
		$self->set_error_message("line_number", $self->gene_model->prefix."(prefix)", $error_message );	
	}
	return $self;
	
}

sub fix_it {

}

sub _concat_to_error_message {
	# TODO: Implement an alternative to creating this rather complicated error message!
		my ($self, $existing_message, $new_message) = @_;
	my $spacer;
	if($existing_message eq ''){
		$spacer = ''; # Don't intend the first message
	}else{
		$spacer = ' ' x length($self->gene_model->prefix."(prefix): ");
	}
	return $existing_message.$spacer.$new_message."\n";

}	







no Moose;
__PACKAGE__->meta->make_immutable;
1;
