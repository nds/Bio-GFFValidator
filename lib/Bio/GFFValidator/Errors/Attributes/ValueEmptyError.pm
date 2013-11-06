package Bio::GFFValidator::Errors::Attributes::ValueEmptyError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that all tags have a value
=method 


=cut

use Moose;
use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'attributes'   	=> ( is => 'ro', isa => 'HashRef', required => 1 ); #A hash of tag => values

sub validate {

	my ($self) = @_;
	
 	for my $tag (keys $self->attributes){
 		my @values = $self->attributes->{$tag};
 		print STDERR "Checking $tag \n";
 		if (not @values){
 			$self->set_error_message("line_number", $tag, "The $tag tag does not contain any values." );	
 		
 		
 		}
 	
 	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;