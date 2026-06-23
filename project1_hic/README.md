# Project 1 — Hi-C analysis

## Objective
Process raw Hi-C paired-end reads into .hic contact maps and compare four samples.

## Samples
- MoPh7
- MoPh11
- MoPh14
- MoPh15

## Pipeline
FASTQ
→ FastQC
→ cutadapt
→ Juicer
→ .hic
→ Juicebox

## Reference
T2T-CHM13v2.0

## Results
No obvious large chromosomal rearrangements were detected.
Differences between samples were mainly explained by sequencing depth.

## Repository structure

scripts/
results/
figures/
