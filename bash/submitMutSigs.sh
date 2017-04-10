#!/bin/bash
dataDir=$1
outDir=$2
projectName=$3
logOdir=$4
logEdir=$5

# ===============================================================
# 		prepare mutational signatures
# ===============================================================
bsub -K -J "generate_catalogs" -o $logOdir/pepareMutSigs.%J.out \
-e $logEdir/pepareMutSigs.%J.out \
-q normal -n 1 -R 'select[mem>=500] rusage[mem=500]' -M500 \
"perl-5.16.3 -I /software/CGP/canpipe/live/lib/perl5/x86_64-linux-thread-multi \
	/software/CGP/projects/MutSignatures/perl/bin/getMutationInformationFastaIndex.pl\
	-i $dataDir/all_variants_bulk.txt\
	-f simple\
	-o $outDir\
	-a /software/CGP/projects/MutSignatures\
	-s human\
	-r /lustre/scratch112/sanger/cgppipe/canpipe/live/ref/Human/GRCh37d5/genome.fa\
	-t /lustre/scratch112/sanger/cgppipe/canpipe/live/ref/Human/GRCh37d5/signatures/e75/signatures.genes.bed.gz"

#-i INPUT_FILE \
#-f FORMAT_OF_INPUT_FILE (this is 'simple' format ) \
#-o OUTPUT_FILE_PREFIX (this is the output_folder/somethig_to_prefix_the_output_files ) \
#-a PATH_TO_ANNOTATIONS \
#-s SPECIES \
#-r REFERENCE_FILE \
#-t TABIX_GTF_TO_BED_FILE

# ===============================================================
# 		run mutational signatures
# ==============================================================
bsub -J "run_signatures" -o $logOdir/runMutSigs.%J.out \
-e $logEdir/runMutSigs.%J.out \
-q long -n 1 -R 'select[mem>=200] rusage[mem=200]' -M200 \
"perl /software/CGP/projects/MutSignatures/perl/bin/signatures.pl\
	-i 1000\
	-c $outDir/$projectName.mut96\
	-max 10\
	-a $projectName\
	-o $outDir/res\
	-f 0.01\
	-d"

#-i ITERATIONS_PER_SIGNATURE (i.e. 1000) \
#-c CATALOG_FILE ( i.e. /lustre/scratch110/sanger/jz1/NMF/colo.mut96 ) \
#-max MAXIMUM_NMBER_OF_SIGNATURES (i.e. 10 ) \
#-a NAME_FOR_THE_ANALYSIS ( i.e. colorectalsWGS ) \
#-o OUTPUT_FOLDER ( i.e. /lustre/scratch110/sanger/jz1/NMF ) \
#-f FILTER (i.e 0.01 removes mutations that contributes less that 1%)
#-d (Produce messages for debugging. This allows IT to quickly tackle a problematic job.)