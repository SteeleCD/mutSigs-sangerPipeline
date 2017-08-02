#!/bin/bash
project=$1
nSigs=$2
resDir=$3
projectName=$4
logOdir=$5
logEdir=$6
mkdir $resDir/prep
mkdir $resDir/inputs
mkdir $resDir/res
# bulk convert
/software/bin/perl-5.14.2 /software/CGP/projects/vcfutil/perl/scripts/BulkConvertVcf.pl -p $project -g -o $resDir/inputs/all_variants_bulk.txt
# prepare substitutions
# bulkFile, outFile, projectName
Rscript --vanilla ../R/prepareMutSignatures.R $resDir/inputs/all_variants_bulk.txt $resDir/inputs/variant_simple.txt $projectName
# run mutational signatures 
source submitMutSigs.sh $nSigs $resDir $projectName $logOdir $logEdir


