package Bio::GFFValidator::GeneModel::Exon;
# ABSTRACT: 

=head1 SYNOPSIS

An Exon class to store information about an exon (CDS)

=method 


=cut

use Moose;

has 'name'				 => ( is => 'rw', isa => 'Str'     ); # Name of the exon/CDS
has 'start'			     => ( is => 'rw', isa => 'Str'     );
has 'end'				 => ( is => 'rw', isa => 'Str'     );
has 'strand'			 => ( is => 'rw', isa => 'Str'     );
has 'phase'				 => ( is => 'rw', isa => 'Str'     );
has 'sequence'			 => ( is => 'rw', isa => 'Str'     ); # We validate the sequence to make sure stop codons are in the right place
has 'parent'			 => ( is => 'rw', isa => 'Str'     );


no Moose;
__PACKAGE__->meta->make_immutable;
1;
