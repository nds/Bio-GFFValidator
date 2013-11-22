package Bio::GFFValidator::GeneModel::UTR;
# ABSTRACT: 

=head1 SYNOPSIS

A UTR class to store information about a UTR

=method 


=cut

use Moose;

has 'name'				 => ( is => 'rw', isa => 'Str'     ); # Name of the UTR
has 'start'			     => ( is => 'rw', isa => 'Str'     );
has 'end'				 => ( is => 'rw', isa => 'Str'     );
has 'strand'			 => ( is => 'rw', isa => 'Maybe[Str]'     );
has 'parent'			 => ( is => 'rw', isa => 'Str'     );


no Moose;
__PACKAGE__->meta->make_immutable;
1;
