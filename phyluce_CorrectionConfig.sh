#!/bin/bash

# This script will create the configuration file for the Phyluce Mapping Workflow. It can be ran for both contig and UCE mapping.
# It was created as an interactive script - add chmod +x permission, execute script and just follow prompt
# Created 14/06/2022 by Lauriane Baraf lauriane.baraf@my.jcu.edu.au

# REQUIREMENTS:
#1 mapped contigs (.fmx.sorted.md.bam) from Phyluce Mapping Workflow
#2 assembled contigs (.fasta)

# NOTES:
# This script assumes that:
# your assembled contigs are named as speciesname.fasta. By default, this is how species names will be retrieved. Please modify this script accordingly if needed.
# your mapped contigs are in .fmx.sorted.md.bam format as per Phyluce pipeline
# Modify present script accordingly if needed.

# OUTPUT:
# The resulting configuration file should be in the YAML format to run in Phyluce-1.7.1 - Make sure to indent the in-sections as followed
# header:
#   {indent} sample name: space/path/to/file
#
# header:
#   {indent} sample name: space/path/to/file

# get user input and define name and out directory 
echo "Enter name of your config file (including exe)"
read name
echo "Give path to where should the output conf file be stored"
read outdir

# get user input and define folders where the data is stored
echo "Enter path to assembled contigs"
read contigs
echo "Enter path to mapped reads folder"
read bams

# create the config file

echo "bams:" > $outdir/$name
for i in $bams/*.fxm.sorted.md.bam; do
        sp=$(basename ${i%.fxm.sorted.md.bam})
        echo "$sp: $i"; >> $outdir/$name
done
echo "" >> $outdir/$name
echo "contigs:" >> $outdir/$name
for f in $contigs/*;do
        sp=$(basename ${f%.fasta})
        echo "$sp: $f" >> $outdir/$name
done

echo "Your config file is ready in $outdir !
Don't forget indent all in-header lines and to double check names.
Best fishes & Happy coding!"
