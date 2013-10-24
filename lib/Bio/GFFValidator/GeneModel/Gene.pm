package Bio::GFFValidator::GeneModel::Gene;
# ABSTRACT: 

=head1 SYNOPSIS

A Gene class to store information about a gene

=method 


=cut

use Moose;

has 'transcripts'        => ( is => 'rw', isa => 'ArrayRef');
has 'name'				 => ( is => 'rw', isa => 'Str'     ); # Name of the gene
has 'start'			     => ( is => 'rw', isa => 'Str'     );
has 'end'				 => ( is => 'rw', isa => 'Str'     );
has 'strand'			 => ( is => 'rw', isa => 'Str'     );
has 'phase'				 => ( is => 'rw', isa => 'Str'     );


sub add_transcript {	
	 my ($self, $transcript) = @_;
	 push ( @{$self->transcripts}, $transcript);
	 return $self;	
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
