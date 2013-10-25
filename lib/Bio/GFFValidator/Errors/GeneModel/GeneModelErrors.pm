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
	
	# We do several gene model checks here. An alternative would be to have separated them out into classes. However, there are checks that can be done together
	# when parsing the gene model and this was considered more efficient
	
	my ($self) = @_;
	my $error_message; # TODO: Format this error message better or can you throw several errors
	
	# Gene model complete? check. If there are any dangling features, we list them 
	if(@{$self->gene_model->dangling_features}){
		$error_message = $error_message."The following features cannot be attached to a gene model: ".join(", ", @{$self->gene_model->dangling_features})."\n";
	
	}
	
	# Are all the feature boundaries within their parent features?
	if(@{$self->gene_model->overhanging_features}){
		$error_message = $error_message."The following features are outside the boundaries of the gene/transcript: ".join(", ", @{$self->gene_model->overhanging_features})."\n";
	
	}
	
	
	
	
	# Set the error message
	if($error_message){
		$self->set_error_message("line_number", $self->gene_model->prefix."(prefix)", $error_message );	
	}
	return $self;
	
}

sub fix_it {

}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
