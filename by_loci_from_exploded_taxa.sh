#!/bin/bash

## This script will parse fasta files exploded by taxon into fasta files exploded by loci.
# It might come in handy if you just want to process a lot of samples down the Phyluce pipeline until the phyluce_assembly_explode_get_fastas_file (--by-taxon) command and then sym link / subset samples into different taxa sets. You can then run this script on your exploded by taxon directories to get fasta files by loci for your multiple sequence alignments.
# To make the script executable - run chmod +x ./by_loci_from_exploded_taxa.sh
# Created 7/11/2022 by Lauriane Baraf lauriane.baraf@my.jcu.edu.au

## REQUIREMENTS:
#1 fasta files exploded by taxon from Phyluce (exe .unaligned.fasat)
#2 assembled contigs (.fasta)

## ADAPT TO YOUR DATA:
# Add path to directory containing fasta files exploded by taxon (line )
# Add path to output directory where fasta files exploded by loci will be stored
# your mapped contigs are in .fmx.sorted.md.bam format as per Phyluce pipeline
# Modify present script accordingly if needed.

## OUTPUT:
# set of UCE directories containing sample genomic sequences in fasta format

## Explode by loci from taxa-filtered exploded files
# Input directory containing species FASTA files
INPUT_DIR="/path/to/fastas_exploded_by_taxon"
# Output directory where per-UCE files will go
OUTPUT_DIR="/path/to/fastas_exploded_by_loci"
mkdir -p "$OUTPUT_DIR"

# Loop through each FASTA file with .unaligned.fasta extension
for fasta_file in "$INPUT_DIR"/*.unaligned.fasta; do
    species=$(basename "$fasta_file" .unaligned.fasta)

    awk -v species="$species" -v outdir="$OUTPUT_DIR" '
        /^>/ {
            # If we already have a UCE and sequence collected, write it
            if (uce != "") {
                print seq >> out
            }
            seq = ""

            # Extract UCE ID from header
            split($0, parts, "\\|")
            gsub(" ", "", parts[2])
            uce = parts[2]
            gsub(">", "", uce)

            out = outdir "/" uce ".unaligned.fasta"
            header = ">" uce "_" species " |" uce
            print header >> out
            next
        }
        {
            seq = seq $0
        }
        END {
            if (uce != "") {
                print seq >> out
            }
        }
    ' "$fasta_file"
done

echo "Done! Fasta files exploded by loci are in: $OUTPUT_DIR"
