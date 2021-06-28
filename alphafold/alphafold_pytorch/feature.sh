#!/bin/bash

TARGET="$1"
# The base directory of the protein input. Should contain a sub directory per protein, e.g. P0DOE4/P0DOE4.fasta
TARGET_DIR="/home/franzi/Projects/cradle/alphafold/proteins/${TARGET}"
TARGET_SEQ="${TARGET_DIR}/${TARGET}.fasta" # fasta format
# Tools to generate the inout
PLMDCA_DIR="/home/franzi/Projects/plmDCA/plmDCA/"
export PATH="/home/franzi/Projects/hh-suite/bin:/home/franzi/Projects/hh-suite/build/scripts:/home/franzi/Program/ncbi-blast-2.11.0+/bin:$PATH"
# generate domain crops from target seq
python feature.py -s $TARGET_SEQ -c
START_TIME=$SECONDS
for domain in ${TARGET_DIR}/*.fasta; do
	out=${domain%.fasta}
	if [ ! -f ${out}.pssm ]; then
	  if [ ! -f ${out}.fas ]; then
      echo "Generate MSA files for ${out}"
      hhblits -cpu 4 -i ${out}.fasta -d /home/franzi/Projects/hh-suite/databases/uniclust30_2018_08/uniclust30_2018_08 -oa3m ${out}.a3m -ohhm ${out}.hhm -n 3
      reformat.pl ${out}.a3m ${out}.fas
    fi
    psiblast -subject ${out}.fasta -in_msa ${out}.fas -out_ascii_pssm ${out}.pssm
  fi
done
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "---- Execution time after MSA generation: $ELAPSED_TIME"
# make target features data and generate ungap target aln file for plmDCA
python feature.py -s $TARGET_SEQ -a

cd $PLMDCA_DIR
for aln in ${TARGET_DIR}/*.aln; do
	echo "calculate plmDCA for $aln"
	octave plmDCA.m $aln
done
cd -
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "---- Execution after all preprocessing steps: $ELAPSED_TIME"
# run again to update target features data
python feature.py -s $TARGET_SEQ -f
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "---- Total execution time: $ELAPSED_TIME"