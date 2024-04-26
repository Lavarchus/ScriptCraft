#!/bin/bash

# This script will create the configuration file for the Phyluce Mapping Workflow. It can be ran for both contig and UCE mapping.
# It was created as an interactive script - add chmod +x permission, execute script and just follow prompt
# Created 14/06/2022 by Lauriane Baraf lauriane.baraf@my.jcu.edu.au

# REQUIREMENTS:
#1 trimmed raw reads (.fasta) - for contig mapping
#2 exploded edge alignment files (.unaligned.fasta) - for UCE mapping
#3 assembled contigs (.fasta)

# NOTES:
# This script assumes that:
# your trimmed reads are stored in directories named after target species. By default, this is how species names will be retrieved. Please modify this script accordingly if needed.
# your exploded fasta files are in unaligned.fasta format as per Phyluce pipeline
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

echo "Enter path to trimmed reads folder"
read reads
echo "Do you want to calculate uce or contig coverage? (uce/contig)"
read uoc

#conditional variable to either uce or contig pathways

if [[ $uoc == "uce" ]];then

    echo "Enter path to exploded fasta files"
    read ucontigs
else
    echo "Enter path to assembled contigs folder"
    read ccontigs
fi

# create the config file

echo "reads:" > $outdir/$name
if [[ $uoc == "uce" ]]; then
    for i in $reads/*; do
        sp=$(basename ${i%.*})
        echo "$sp: $i"
    done
    echo "" >> $outdir/$name
    echo "contigs:" >> $outdir/$name
    for f in $ucontigs/*.fasta; do
        sp=$(basename $f .unaligned.fasta)
        echo "$sp: $f" >> $outdir/$name
    done
else
    for i in $reads/*;do
        sp=$(basename ${i%.*})
        echo "$sp: $i" >> $outdir/$name
    done
    echo "" >> $outdir/$name
    echo "contigs:" >> $outdir/$name
    for i in $ccontigs/*; do
        path_to_reads="$reads"
        sp=$(basename ${path_to_reads%.*})
        echo "$sp: $i" >> $outdir/$name
    done
fi

echo "Your config file is ready in $outdir !
Don't forget indent all in-header lines and to double check names.
Best fishes & Happy coding!"







