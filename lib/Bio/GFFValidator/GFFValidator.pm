package Bio::GFFValidator::GFFValidator;

# ABSTRACT: Validates a given GFF file and produces an error report

=head1 SYNOPSIS

Passes the GFF file into the parser module and receives a set of features and gene models. These are then passed into the appropriate validator checks.
Any errors found are passed to the Error Handlers.

my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   gff_file =>  't/data/sample.gff3');
$gff_validator->run();

=head1 SEE ALSO

=for :list

=cut

use Moose;
use Cwd;
use File::Basename;

use Bio::GFFValidator::Parser::Main;
use Bio::GFFValidator::Feature::Feature;
use Bio::GFFValidator::Errors::ID::IDFormatError;
use Bio::GFFValidator::Errors::ID::IDEmptyError;
use Bio::GFFValidator::Errors::Parser::ParserError;
use Bio::GFFValidator::Errors::Start_and_End::NotWithinRangeError;
use Bio::GFFValidator::Errors::Start_and_End::NotPositiveIntegerError;
use Bio::GFFValidator::Errors::Start_and_End::StartNotLessThanEndError;
use Bio::GFFValidator::Errors::Strand::StrandNotInRightFormatError;
use Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError;
use Bio::GFFValidator::Errors::Type::TypeEmptyError;
use Bio::GFFValidator::Errors::Attributes::NonReservedTagsStartingWithUpperCaseError;
use Bio::GFFValidator::Errors::Attributes::ValueEmptyError;
use Bio::GFFValidator::Errors::Attributes::ID::IDNotUniqueError;
use Bio::GFFValidator::Errors::Attributes::MultipleValuesError;
use Bio::GFFValidator::Errors::GeneModel::GeneModelErrors;
use Bio::GFFValidator::ErrorHandlers::PrintReport;
use Bio::GFFValidator::ErrorHandlers::PrintSummary;


has 'gff_file'                => ( is => 'ro', isa => 'Str',  required => 1 );
has 'error_report'	          => ( is => 'rw', isa => 'Str',  lazy     => 1, builder => '_build_error_report' ); #Default to a file named with the gff filename + ERROR_REPORT.txt
has 'error_summary_report'	  => ( is => 'rw', isa => 'Str',  lazy     => 1, builder => '_build_error_summary_report' ); #Default to a file named with the gff filename + ERROR_SUMMARY_REPORT.txt
has 'handler_option'          => ( is => 'ro', isa => 'Num', default => 1); # 1 - print errors in a report, 2 - print a summary, 3 - fix errors (not implemented yet)


sub _build_error_report {
  my ($self) = @_;
  return getcwd()."/".basename($self->gff_file).".ERROR_REPORT.txt"; 
}

sub _build_error_summary_report {
  my ($self) = @_;
  return getcwd()."/".basename($self->gff_file).".ERROR_SUMMARY_REPORT.txt"; 
}

sub run {
	my ($self) = @_;

	my @errors_found;
	my %ids;
	
		
	# Parse the GFF file. 
	# Catch errors thrown by the Bio Perl parser. Bio Perl still dies whenever an error is found, even though we try to catch it.
	# TODO: Do some monkey patching of Bio::Root::Exception to see if this can be fixed
	
	my $gff_parser = Bio::GFFValidator::Parser::Main->new(gff_file => $self->gff_file);
	local $@;
	eval {
		$gff_parser->parse();
	};

	if(my $exception = $@){ 
		my $parser_errors = (Bio::GFFValidator::Errors::Parser::ParserError->new(exception => $exception))->validate();
		push(@errors_found, $parser_errors);
	}
	
	# Run the tests for all the features returned by the parser
	my $arrayref = $gff_parser->features;	
	for my $feature (@$arrayref){
	
		# ID errors (column 1)
		my $idempty_error = (Bio::GFFValidator::Errors::ID::IDEmptyError->new(feature => $feature))->validate();
		push(@errors_found, $idempty_error);
		
		# Source (column 2)
		
		
		# Type (column 3)
		my $typeempty_error = (Bio::GFFValidator::Errors::Type::TypeEmptyError->new(feature => $feature))->validate();
		push(@errors_found, $typeempty_error);
	
	
		# Start and end (columns 4 and 5)
		my $notpositiveinteger_error = (Bio::GFFValidator::Errors::Start_and_End::NotPositiveIntegerError->new(feature => $feature))->validate();
		push(@errors_found, $notpositiveinteger_error);
		my $startnotlessthanend_error = (Bio::GFFValidator::Errors::Start_and_End::StartNotLessThanEndError->new(feature => $feature))->validate();
		push(@errors_found, $startnotlessthanend_error);
		my $notwithinrange_error = (Bio::GFFValidator::Errors::Start_and_End::NotWithinRangeError->new(feature => $feature, seq_regions => $gff_parser->seq_regions ))->validate();
		push(@errors_found, $notwithinrange_error);
		
		# Score (column 6) - no checks at the moment as specification sketchy
		
		# Strand (column 7) 
		my $strandnotinrightformat_error = (Bio::GFFValidator::Errors::Strand::StrandNotInRightFormatError->new(feature => $feature))->validate();
		push(@errors_found, $strandnotinrightformat_error);
		
		# Phase (column 8)
		my $cdsmissingphase_error = (Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError->new(feature => $feature))->validate();
		push(@errors_found, $cdsmissingphase_error);
		
		# Attributes (column 9)
		my %attributes = (Bio::GFFValidator::Feature::Feature->new(feature => $feature))->get_attributes_for_feature();
		for my $tag (keys %attributes){
			# Only reserved tags can start with capital letters
			my $nonreservedtagsstartingwithuppercase_error = (Bio::GFFValidator::Errors::Attributes::NonReservedTagsStartingWithUpperCaseError->new(tag => $tag, feature_id => $feature->seq_id))->validate();
			push(@errors_found, $nonreservedtagsstartingwithuppercase_error);
			
			# Some tags are not allowed multiple values
			if($tag =~ m/ID|Name|Target|Gap|Parent/){			
				my $multiplevalues_error = (Bio::GFFValidator::Errors::Attributes::MultipleValuesError->new(tag => $tag, tag_values => $attributes{$tag}, feature_id => $feature->seq_id))->validate();
				push(@errors_found, $multiplevalues_error);
			}
			
			# Collect the IDS to do a uniqueness test later on
			if($tag =~ m/ID/){
				my $value = $attributes{$tag}[0];
				$ids{$value}++;
			}

		}
	}
	
	# Check the uniqueness of the IDs for this GFF file	
	my $idnotunique_error = (Bio::GFFValidator::Errors::Attributes::ID::IDNotUniqueError->new(ids => \%ids))->validate();
	push(@errors_found, $idnotunique_error);
	
	# Validate the gene models
	for my $gene_model (@{$gff_parser->gene_models}){
		my $genemodel_error = (Bio::GFFValidator::Errors::GeneModel::GeneModelErrors->new(gene_model => $gene_model))->validate();
		push(@errors_found, $genemodel_error);
	}	
	
	# Handle all the errors found
	if($self->handler_option == 1){ # Print errors into a report
		my $report_printer = Bio::GFFValidator::ErrorHandlers::PrintReport->new(gff_file => $self->gff_file, errors => \@errors_found, error_report => $self->error_report);
		$report_printer->print();
	}elsif($self->handler_option == 2)){
		my $summary_printer = Bio::GFFValidator::ErrorHandlers::PrintSummary->new(gff_file => $self->gff_file, errors => \@errors_found, error_summary_report => $self->error_summary_report);
		$report_printer->print();
	}elsif($self->handler_option == 3)) { #Get the validator to fix errors (if option 3)
	 
	 	# not yet implemented
	 
	}
	

   return $self;
   
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
