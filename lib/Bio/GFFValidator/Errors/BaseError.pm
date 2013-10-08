package Bio::GFFValidator::Errors::BaseError;
# ABSTRACT: 

=head1 SYNOPSIS

Base Error class from which other error classes will inherit

=method 


=cut

use Moose;

has 'line_number'        => ( is => 'rw', isa => 'Str');
has 'value'        	     => ( is => 'rw', isa => 'Str');
has 'message'        	 => ( is => 'rw', isa => 'Str');

sub validate {
	# Do the validation check
	# Set the line number, value and message
}

sub get_error_message {
	my ($self) = @_;
	return $self->line_number.": ".$self->value." ".$self->message."\n";
}


sub fix_it {
  	# How to fix the error if it can be fixed
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
