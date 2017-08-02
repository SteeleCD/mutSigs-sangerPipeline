#!/bin/bash
nSigs=$1
dataDir=$2
projectName=$3
logOdir=$4
logEdir=$5
echo "CLUSTER MUT SIG INPUTS"
echo "dataDir: $dataDir"
echo "projectName: $projectName"
echo "logOdir: $logOdir"
echo "logEdit: $logEdir"

echo "SUBMIT PREPARATION OF MUT SIGS"
# ===============================================================
# 		prepare mutational signatures
# ===============================================================
bsub -K -J "generate_catalogs-$2" -o $logOdir/pepareMutSigs-$2.%J.out \
-e $logEdir/pepareMutSigs-$2.%J.out \
-q normal -n 1 -R 'select[mem>=500] rusage[mem=500]' -M500 \
"perl-5.16.3 -I /software/CGP/canpipe/live/lib/perl5/x86_64-linux-thread-multi \
	/software/CGP/projects/MutSignatures/perl/bin/getMutationInformationFastaIndex.pl\
	-i $dataDir/inputs/variant_simple.txt\
	-f simple\
	-o $dataDir/prep/$projectName\
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
bsub -J "run_signatures-$2" -o $logOdir/runMutSigs-$2.%J.out \
-e $logEdir/runMutSigs-$2.%J.out \
-q long -n 1 -R 'select[mem>=4000] rusage[mem=4000]' -M4000 \
"perl /software/CGP/projects/MutSignatures/perl/bin/signatures.pl\
	-i 1000\
	-c $dataDir/prep/$projectName.mut96\
	-max $nSigs\
	-a $projectName\
	-o $dataDir/res\
	-f 0.01\
	-d"

#-i ITERATIONS_PER_SIGNATURE (i.e. 1000) \
#-c CATALOG_FILE ( i.e. /lustre/scratch110/sanger/jz1/NMF/colo.mut96 ) \
#-max MAXIMUM_NMBER_OF_SIGNATURES (i.e. 10 ) \
#-a NAME_FOR_THE_ANALYSIS ( i.e. colorectalsWGS ) \
#-o OUTPUT_FOLDER ( i.e. /lustre/scratch110/sanger/jz1/NMF ) \
#-f FILTER (i.e 0.01 removes mutations that contributes less that 1%)
#-d (Produce messages for debugging. This allows IT to quickly tackle a problematic job.)
