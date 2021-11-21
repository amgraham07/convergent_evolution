#!/usr/bin/perl
use strict;
use warnings;

my $startRun = time();

my $executable = '/Users/alliegraham/Desktop/BayesTraitsV3.0.2-OSX/BayesTraitsV3';
#my $executable = '/Users/nathan/bin/BayesTraits';

my $script1 = './bt_indep.txt';
my $script2 = './bt_dep.txt';

my $file_trait = $ARGV[0];
my $file_genes = './DATA_new_pseudo_combined_highalt_v1.tsv';
my $file_tree = './TREE_new_pseudo_hsa_2.nex';
my $th_n0_min = 2; # THRESHOLD: minimum number of species with lost gene for gene to be considered
my $th_n1_min = 10; # THRESHOLD: minimum number of species with intact gene for gene to be considered
my $gene_to_analyze = 'ENSG00000141034';		### for debugging ########  <----------- DEBUGGING

# Read and store gene presence/absence data in hash %data, store species names and order in @species
open( DATA, '<', $file_genes ) or die "Can't open $file_genes: $!";
my $firstLine = <DATA>;
my @species = split /\t/, $firstLine;
s{^\s+|\s+$}{}g foreach @species; #stripping leading and trailing blank spaces in string
shift @species;	#remove "gene" column header
my $n_species = scalar @species;

my %data;
my %n1_pattern;
my %n0_pattern;
my %pattern;
my %tally;
my $count;
foreach my $line (<DATA>) {
	chomp $line;
	my @array = split /\t/, $line;
	s{^\s+|\s+$}{}g foreach @array;
	my $gene = shift @array;
#	next unless $gene eq $gene_to_analyze;	### for debugging ########  <----------- DEBUGGING
	my $n1=0;
	my $n0=0;

	my $string = join '' , @array;
	$data{$string} = \@array;

	foreach (@array) {
		next if $_ =~ /\D/; #ignoring missing identifiers (ie. NA, x, -)
		$n1++ if $_ == 1;
		$n0++ if $_ == 0;
	}	
	$n1_pattern{$string} = $n1;
	$n0_pattern{$string} = $n0;

	$pattern{$gene} = $string;

	if (defined $tally{$string}) {
		$tally{$string}++;
	} else {
		$tally{$string} = 1;
	}
}
close DATA || die "Couldn't close file properly.";

print STDERR "Number of patterns: " , scalar keys %tally , "\n";
#foreach my $p (sort keys %tally) {
#	print STDERR "$p	$tally{$p}\n";
#}



# Read and store trait data in hash %trait
open( TRAIT, '<', $file_trait ) or die "Can't open $file_trait: $!";
my %trait;
foreach my $line (<TRAIT>) {
	chomp $line;
	my @array = split /\t/, $line;
	s{^\s+|\s+$}{}g foreach @array;
	$trait{$array[0]} = $array[1];
}
close TRAIT || die "Couldn't close file properly.";


my %result;
my $i=0;
foreach my $k (sort keys %data) {
	$count++;
	next if $n0_pattern{$k} < $th_n0_min;
	next if $n1_pattern{$k} < $th_n1_min;
	open( INFILE , '>', $file_genes.".infile" );
	for (my $i=0; $i<$n_species; $i++) {
		my $s = $species[$i];
		print INFILE "$s	$trait{$s}	$data{$k}->[$i]\n";
	}
	close INFILE;

	my @indep = `$executable $file_tree $file_genes."infile" < $script1`;
	my @dep   = `$executable $file_tree $file_genes."infile" < $script2`;
	chomp $indep[-2];
	$indep[-2] =~ s/\t$//;
	chomp $dep[-2];
	$dep[-2] =~ s/\t$//;
	
	$result{$k} = "$indep[-2]	$dep[-2]";
	print STDERR "$count ";
}
print STDERR "\n";

foreach my $g (sort keys %pattern) {
	my $p = $pattern{$g};
	print "$g	$n1_pattern{$p}	$result{$p}\n";		
}

my $endRun = time();
my $runTime = $endRun - $startRun;
print STDERR "\nRUNTIME	$runTime\n";

exit;