#!/usr/bin/perl -w
use strict;

# This script selects alignments with a minimum number of species and copies them to another folder.
my $usage = "\n filter_aln_species.pl <file of fasta file names> <minimum species>
\tMoves alignment files into new directories \'above\' or \'below\' based on minimum number of species.
\tCreate a file of files as such: ls -1 *.fasta > fof\n\n";
unless (scalar @ARGV == 2) {
	die $usage;
}
my $th = $ARGV[1]; #set minimum number of species for an alignment be included in final set.
mkdir "above" , 0755 unless (-e "above");
mkdir "below" , 0755 unless (-e "below");

foreach my $file (read_input($ARGV[0])) {  #Input a fof
	chomp $file;
	my $seq = in_fasta(read_input("$file"));
	
	my $n = scalar keys %{$seq};
	print STDOUT "$file\t$n\n";

	if ($n >= $th) {
		system "mv $file above";
	} elsif ($n < $th) {
		system "mv $file below";	
	}
}
exit;


sub read_input {
	my ($inputName) = @_;
	open INPUT, $inputName or die "Could not open $inputName";
	my @input = <INPUT>;
	close INPUT;
	return @input;
}

sub in_fasta {
	#input array of lines
	#output hash reference of sequences
	my %seq;
	my $name='';
	my $s='';	
	foreach my $line (@_) {
		chomp $line;

        # discard blank line
        if ($line =~ /^\s*$/) {
            next;
        # discard comment line
        } elsif($line =~ /^\s*#/) {
            next;
        }

		if ($line =~ /^>(\S+)/) {
			$seq{$name} = $s if $name;
			$name = $1;
			$s = '';
		} else {
			$line =~ s/\s+//g;
			$s .= $line;
		}
	}
	$seq{$name} = $s;
	return \%seq;
}
