package Bio::GFFValidator::GeneModel::Exon;
# ABSTRACT: 

=head1 SYNOPSIS

An exon class

=method 


=cut

use Moose;

extends "Bio::SeqFeature::Generic";


no Moose;
__PACKAGE__->meta->make_immutable;
1;