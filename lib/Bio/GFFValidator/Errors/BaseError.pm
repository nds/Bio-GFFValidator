package Bio::GFFValidator::Errors::BaseError;
# ABSTRACT: 

=head1 SYNOPSIS

Base Error class from which other error classes will inherit. 

=method 


=cut

use Moose;

has 'line_number'        => ( is => 'rw', isa => 'Str'); #Line number in the GFF file. Difficult to extract when parsed with Bio Perl. Not used for now.
has 'value'        	     => ( is => 'rw', isa => 'Str'); # Sometimes set by the individual error class. If not set, then the feature ID will be used in set_error_message (if a feature object exists)
has 'message'        	 => ( is => 'rw', isa => 'Str'); # Message to the user
has 'triggered'          => ( is => 'rw', isa => 'Bool', default  => 0 ); # Set to true if the test has failed

sub validate {
	# Do the validation check
	# Set the line number, value and message
}

sub set_error_message {
	my ($self, $line_number, $value, $message) = @_;
	$self->line_number($line_number);
	$self->value($self->_set_value($value));
	$self->message($message);
	$self->triggered(1);
	return $self;
}

sub get_error_message {
	my ($self) = @_;
	return $self->line_number.": ".$self->value.": ".$self->message;
}


sub fix_it {
  	# How to fix the error if it can be fixed
}

# If a value has been set by the individual error class, then use that
# If not, try to get the feature ID. 
# If there is no feature object, return "-"
sub _set_value {
	my ($self, $value) = @_;
	if($value){
		return $value;
	}else{
		if($self->feature){
			return (Bio::GFFValidator::Feature::Feature->new(feature => $self->feature))->get_feature_ID();
		
		}else{
			return "-";
		
		}
	
	}


}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
