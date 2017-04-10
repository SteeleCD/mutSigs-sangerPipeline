#!/bin/bash
project=$1
resDir=$2
projectName=$3
logOdir=$4
logEdir=$5
mkdir $resDir/prep
# bulk convert
/software/bin/perl-5.14.2 /software/CGP/projects/vcfutil/perl/scripts/BulkConvertVcf.pl -p $project -g -o $resDir/prep/all_variants_bulk.txt
# prepare substitutions
# bulkFile, outFile, projectName
Rscript --vanilla ../R/prepareMutSignatures.R $resDir/prep/all_variants_bulk.txt $resDir/prep/variant_simple.txt $projectName
# run mutational signatures 
mkdir $resDir/out
source submitMutSigs.sh $resDir/prep $resDir/out $projectName $logOdir $logEdir


