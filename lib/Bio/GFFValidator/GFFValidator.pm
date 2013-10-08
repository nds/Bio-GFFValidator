package Bio::GFFValidator::GFFValidator;
# ABSTRACT: Validates a given GFF file and produces an error report

=head1 SYNOPSIS



=head1 SEE ALSO

=for :list

=cut

use Moose;

use Bio::GFFValidator::Parser::Main;

use Bio::GFFValidator::ErrorHandlers::ParserErrorHandler;
use Bio::GFFValidator::Errors::IDErrors;


has 'gff_file'        => ( is => 'ro', isa => 'Str',  required => 1 );
has 'error_report'	  => ( is => 'rw', isa => 'Str',  lazy     => 1, builder => '_build_error_report' );


sub run
{
	my ($self) = @_;
	my $gff_parser = Bio::GFFValidator::Parser::Main->new(gff_file => $self->gff_file);
	eval {
		$gff_parser->parse();
	};
	
	# Handle errors thrown by the Bio Perl parser
	if(my $exception = $@){ 
		my $error_handler = Bio::GFFValidator::ErrorHandlers::ParserErrorHandler->new(exception => $exception);
		$error_handler->handle;
	}

	# for my $feature(@{$gff_parser->get_features}){
# 
# 		# Handle errors in the ID column
# 		
#         my $ID_errors = Bio::GFFValidator::Errors::IDErrors->new(id => $feature->seq_id);
#         $ID_errors->validate();
# 	
# 	
# 	
# 	}

	
	# Run tests for each gene model
	# for my $gene_model(@{$gff_parser->get_gene_models}){
# 	
# 	
# 	
# 	}
# 	
   
   
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
