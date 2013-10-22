package Bio::GFFValidator::GeneModel::Gene;
# ABSTRACT: 

=head1 SYNOPSIS

A Gene class to help us keep hold of genes together with links to their transcripts

=method 


=cut

use Moose;
use Data::Dumper;

extends "Bio::SeqFeature::Generic";

has 'transcripts'        => ( is => 'rw', isa => 'ArrayRef');
has 'prefix'			 => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_prefix' );

sub _build_prefix {	
	# For a gene line in a GFF file, this would be the gene's ID (name)
	my ($self) = @_;
	my @values = $self->each_tag_value('ID');
	return $values[0]; #This assumes there is one and only one value for ID. Need to verify this is the case
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
