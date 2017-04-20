#!/bin/bash
project=$1
resDir=$2
projectName=$3
logOdir=$4
logEdir=$5
mkdir $resDir/prep
mkdir $resDir/inputs
mkdir $resDir/res
# bulk convert
/software/bin/perl-5.14.2 /software/CGP/projects/vcfutil/perl/scripts/BulkConvertVcf.pl -p $project -g -o $resDir/inputs/all_variants_bulk.txt
# prepare substitutions
# bulkFile, outFile, projectName
Rscript --vanilla ../R/prepareMutSignatures.R $resDir/inputs/all_variants_bulk.txt $resDir/inputs/variant_simple.txt $projectName
# run mutational signatures 
source submitMutSigs.sh $resDir $projectName $logOdir $logEdir


