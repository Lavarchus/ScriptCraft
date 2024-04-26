#!/bin/bash

# This script can be run to create the configuration file that's necessary to run during the phasing of uces to contigs in the Phyluce pipeline.
# Created 14/06/2022 by Lauriane Baraf lauriane.baraf@my.jcu.edu.au
# What to do to run it on your data:
# paths to the fxm.sorted.md.bam files that were created in the previous mapping step and the contigs fasta files, if the former hasn't been done, refer to the UCE mapping workflow for the Phyluce pipeline 
# Time to run: 1sec

# This script assumes that your mapped read folder is set as per the Phyluce tutorial so path/to/mappedreads/*.fxm.sorted.md.bam
# for exploded fasta files path/to/explodedfastas/*.fasta
# for assembled contigs path/to/contigs/*.fasta

# The resulting configuration file should be in the YAML format to run in Phyluce-1.7.1
# header:
#   indent sample name: space/path/to/file
#
# header:
#   indent sample name: space/path/to/file

# get user input and define name and out directory 
echo "How do you want to name your config file (including exe)"
read name
echo "Give path to where it should be stored"
read outdir

# get user input and define folders where the data is stored

echo "Enter path to mapped reads folder"
read bams

echo "Do you want to phase uce or contigs? (uce/contig)"
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

echo "bams:" > $outdir/$name
cd $bams
if [[ $uoc == "uce" ]];then
    for i in *.fxm.sorted.md.bam;do
        names=${i%.fxm.sorted.md.bam}
        echo $names": $bams/"$i""; \
    done >> $outdir/$name
    echo >> $outdir/$name
    echo "contigs:" >> $outdir/$name
    cd $ucontigs
    for f in *.fasta;do
        fnames=${f%.fasta}
        echo $fnames": $ucontigs/$f"; \
    done >> $outdir/$name

else
    for i in *.fxm.sorted.md.bam;do
        names=${i%.fxm.sorted.md.bam}
        echo $names": $bams/"$i""; \
    done >> $outdir/$name
    echo >> $outdir/$name
    echo "contigs:" >> $outdir/$name
    cd $ccontigs
    for f in *.contigs.fasta;do
        fnames=${f%.contigs.fasta}
        echo $fnames": $ccontigs/"$f""; \
    done >> $outdir/$name
fi

echo "Your config file is ready in $outdir !
Don't forget to double check names and indent all in-header lines.
Best fishes & Happy coding!"
