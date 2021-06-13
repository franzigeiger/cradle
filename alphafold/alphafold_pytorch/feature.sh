#!/bin/bash

TARGET="carboxylic_ester"
TARGET_DIR="/home/franzi/Projects/cradle/alphafold/data"
#TARGET_SEQ="${TARGET_DIR}/${TARGET}.seq" # fasta format
TARGET_SEQ="/home/franzi/Projects/cradle/alphafold/data/3_1_1_1__Q9LMA7__BRENDA_sequence.fasta" # fasta format
PLMDCA_DIR="/home/franzi/Projects/plmDCA/plmDCA/"
export PATH="/home/franzi/Projects/hh-suite/build/bin:/home/franzi/Projects/hh-suite/scripts:/home/franzi/Program/ncbi-blast-2.11.0+/bin:$PATH"
# generate domain crops from target seq
#python feature.py -s $TARGET_SEQ -c
#
#for domain in ${TARGET_DIR}/*.fasta; do
#	out=${domain%.fasta}
#	echo "Generate MSA files for ${out}"
#	hhblits -cpu 4 -i ${out}.fasta -d /home/franzi/Projects/hh-suite/databases/uniclust30_2018_08/uniclust30_2018_08 -oa3m ${out}.a3m -ohhm ${out}.hhm -n 3
#	reformat.pl ${out}.a3m ${out}.fas
#	psiblast -subject ${out}.fasta -in_msa ${out}.fas -out_ascii_pssm ${out}.pssm
#done

# make target features data and generate ungap target aln file for plmDCA
#python feature.py -s $TARGET_SEQ -f
#
#cd $PLMDCA_DIR
#for aln in ${TARGET_DIR}/*.aln; do
#	echo "calculate plmDCA for $aln"
#	octave plmDCA.m $aln
#done
#cd -

# run again to update target features data
python feature.py -s $TARGET_SEQ -f