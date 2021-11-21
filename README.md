# convergent_evolution projects (University of Utah)
## This repository includes odds-and-ends associated with Clark Lab projects, in the form of scripts and instructions
### Some of these scripts have been featured in various publications during my NIH T32 Hematology postdoctoral fellowship, including: TBA
### Project 1: Determining similar genetic pathways used by multiple high-altitude invading lineages
#### [1] RERConverge_Hypoxia.R: walkthrough using RERConverge package for "hypoxia" phenotype
#### [2] bt_run.pl: script to run BayesTraits. Input needed are trait file, pseudo gene counts, nexus tree, independant and depenant binary test file (N.Clark)
#### [3] filter_aln_species.pl: Perl script to filter fasta alignments based on number of sequences. To read the usage, run it without arguments (N.Clark)

### Project 2: Determining pseudogenization events associated with high-altitude adaptation
#### [4] PGLS: Walkthrough of how to perform a Phlogenetics Generalized Least Squares analysis courtesy of https://lukejharmon.github.io/ilhabela/instruction/2015/07/03/PGLS/ and https://www.r-phylo.org/wiki/HowTo/PGLS
#### [5] OR_counts.sh: Shell script to go through full protein files from genomes and count olfactory receptor genes, that have been filtered to those containing a specific protein domain (7tm4)

### Project 3: Determining similar genetic mechanisms asscoiated with blood-feeding in insect lineages
#### [6] rename_files_combined.sh: #1 based on files filtered from OrthoDB into orthogroups - renames files to refer to orthogroup rather than random number
#### [7] rename_species_combined.sh: #2 based on files filtered from OrthoDB into orthogroups - renames orthoDB-specific species identifiers to new names
#### [8] create_species_counts.sh: #3 based on files filtered from OrthoDB into orthogroups - combines the species counts into one file in table format
