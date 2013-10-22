package Bio::GFFValidator::GeneModel::Transcript;
# ABSTRACT: 

=head1 SYNOPSIS

A Transcript class to help us keep hold of transcripts together with links to their exons, utrs etc

=method 


=cut

use Moose;

extends "Bio::SeqFeature::Generic";

has 'exons'        => ( is => 'rw', isa => 'ArrayRef');


no Moose;
__PACKAGE__->meta->make_immutable;
1;
