#!/bin/bash

## This script will symlink all unaligned taxon files from multiple exploded-fastas directories into a new directory for specific subset of taxa.
# To make the script executable - run chmod +x ./filter_exploded_taxa.sh
# Created 7/11/2022 by Lauriane Baraf lauriane.baraf@my.jcu.edu.au

## REQUIREMENTS:
#1 directory with fasta files exploded by taxon from Phyluce (exe .unaligned.fasta)
#2 text file with sample list named ${taxa}_samples.txt

## ADAPT TO YOUR DATA:
# Define name for taxa subset - this will be how your new directory and log file will be named (line 24)
# Add path to all directories containing fasta files exploded by taxon (line 27-41)
# Define OUTDIR to where you want your symlinks to be stored (line 44)
# Define SAMPLE_LIST - path to text file containing sample list (line 47)
# Feel free to modify the present script accordingly if needed.

## OUTPUT:
# Directory labelled $taxa containing symbolink links to unaligned exploded fasta files (by-taxon)
# Log file named ${taxa}_missing_samples.log with exploded fasta files that could not be found to help identify missing samples

# Define job s name
taxa="trachyphyllia"

# Define the source directory (where the original files are located)
SOURCE_DIRS=(
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C1_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C2_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C3_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C4_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C5_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C6_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C6b_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C7_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/C8_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/aqua_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/nico-ga_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/nico-md_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/nico-reu_exploded-fastas/by_taxon"
    "/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/nico-acroFP_exploded-fastas/by_taxon"
)

# Define the target directory (where the symlinks will be created)
OUTDIR="/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/${taxa}_exploded-fastas/by_taxa"

# Define the file containing the list of filenames
SAMPLE_LIST="/gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/subsets/${taxa}_samples.txt"

# define log file for missing samples
LOG="${taxa}_missing_samples.log"
echo "List of missing samples for $taxa " > /gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/subsets/$LOG

# Ensure the target directory exists
mkdir -p "$OUTDIR"

# Read each sample name from the file list
while IFS= read -r sample || [[ -n "$sample" ]]; do
    # Construct the expected filename
    target_filename="$sample.unaligned.fasta"
    found_file="" # Variable to store the path if found

    # Loop through each source directory to find the file
    for source_dir in "${SOURCE_DIRS[@]}"; do
        potential_file="$source_dir/$target_filename"
        if [[ -e "$potential_file" ]]; then
            found_file="$potential_file"
            break # File found, no need to check other source directories
        fi
    done

    # Check if the file was found in any of the source directories
    if [[ -n "$found_file" ]]; then
        # Create the symbolic link in the target directory
        ln -s "$found_file" "$OUTDIR/$target_filename"
        echo "Created symlink for: $target_filename (from $found_file)"
    else
        # Log an error if the file was not found in any source directory
        echo "ERROR: File not found in any SOURCE_DIRS - $target_filename" >&2
        echo "$target_filename" >> /gpfs01/v2/Q5485/target_capture/coral/5_exploded_fasta/subsets/$LOG
    fi
done < "$SAMPLE_LIST"

echo "Done! Check '$OUTDIR' for symlinks and '$LOG' for missing files."
