package Bio::GFFValidator::GeneModel::Transcript;
# ABSTRACT: 

=head1 SYNOPSIS

A Transcript class to store information about a transcript

=method 


=cut

use Moose;

has 'exons'       		 => ( is => 'rw', isa => 'ArrayRef'); # CDS
has 'polypeptides'       => ( is => 'rw', isa => 'ArrayRef'); # Derived from a transcript
has 'utrs'       		 => ( is => 'rw', isa => 'ArrayRef');
has 'name'				 => ( is => 'rw', isa => 'Str'     ); 
has 'start'			     => ( is => 'rw', isa => 'Str'     );
has 'end'				 => ( is => 'rw', isa => 'Str'     );
has 'strand'			 => ( is => 'rw', isa => 'Str'     );
has 'phase'				 => ( is => 'rw', isa => 'Str'     );
has 'parent'			 => ( is => 'rw', isa => 'Str'     );


sub add_exon {	
	 my ($self, $exon) = @_;
	 push ( @{$self->exons}, $exon);
}

sub add_polypeptide {	
	 my ($self, $polypeptide) = @_;
	 push ( @{$self->polypeptide}, $polypeptide);
}

sub add_utr {	
	 my ($self, $utr) = @_;
	 push ( @{$self->utrs}, $utr);
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
