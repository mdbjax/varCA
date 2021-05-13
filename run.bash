#!/usr/bin/env bash

# An example bash script demonstrating how to run the entire snakemake pipeline
# This script creates two separate log files:
# 	1) log - the basic snakemake log of completed rules
# 	2) qlog - a more detailed log of the progress of each rule and any errors

# Before running the snakemake pipeline, remember to complete the config.yaml
# file in the configs/ folder with the required input info. In particular,
# make sure that you have created a samples.tsv file specifying paths to the
# fastq (or bam) files for each of your samples.
# Make sure that this script is executed from the directory that it lives in!

# you should specify a directory for all output here, rather than in the config
# this will override whichever output directory appears in the config
out_path="results"
mkdir -p "$out_path"

# clear leftover log files
if [ -f "$out_path/log" ]; then
	echo ""> "$out_path/log";
fi
if [ -f "$out_path/qlog" ]; then
	echo ""> "$out_path/qlog";
fi

snakemake --cluster "sbatch -q batch -c 1 --mem=4G -t 24:00:00 -o $out_path/qlog" \
	 --config out="$out_path" \
	--latency-wait 60 -k -j \
	--use-conda "$@" 2>"$out_path/log" >"$out_path/qlog"


# check: should we execute via qsub?
#if [[ $* == *--sge-cluster* ]]; then
#	snakemake \
#	--cluster "qsub -t 1 -V -j y -cwd -o $out_path/qlog" \
#	--config out="$out_path" \
#	--latency-wait 60 \
#	--use-conda \
#	-k \
#	-j \
#	${@//--sge-cluster/} &>"$out_path/log"
#else
#	snakemake \
#	--config out="$out_path" \
#	--latency-wait 60 \
#	--use-conda \
#	-k \
#	-j \
#	"$@" 2>"$out_path/log" >"$out_path/qlog"
#fi

