package Bio::GFFValidator::GeneModel::Polypeptide;
# ABSTRACT: 

=head1 SYNOPSIS

A polypeptide class to store information about a polypeptide

=method 


=cut

use Moose;

has 'name'				 => ( is => 'rw', isa => 'Str'     ); # Name of the polypeptide
has 'start'			     => ( is => 'rw', isa => 'Str'     );
has 'end'				 => ( is => 'rw', isa => 'Str'     );
has 'strand'			 => ( is => 'rw', isa => 'Str'     );
has 'phase'				 => ( is => 'rw', isa => 'Str'     );
has 'parent'			 => ( is => 'rw', isa => 'Str'     );


no Moose;
__PACKAGE__->meta->make_immutable;
1;
