#!/usr/bin/env bash
set -euo pipefail

THREADS=4

SAMPLES=("MoPh7" "MoPh11" "MoPh14" "MoPh15")

for SAMPLE in "${SAMPLES[@]}"; do
    echo "=============================="
    echo "Processing ${SAMPLE}"
    echo "=============================="

    echo "[1] FastQC"
    fastqc \
        data/raw/${SAMPLE}_R1.fastq.gz \
        data/raw/${SAMPLE}_R2.fastq.gz \
        -o results/fastqc_raw

    echo "[2] cutadapt"
    cutadapt \
        -q 20 \
        -m 70 \
        -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -o data/trimmed/${SAMPLE}_R1.trimmed.fastq.gz \
        -p data/trimmed/${SAMPLE}_R2.trimmed.fastq.gz \
        data/raw/${SAMPLE}_R1.fastq.gz \
        data/raw/${SAMPLE}_R2.fastq.gz \
        > results/cutadapt/${SAMPLE}.cutadapt.log 2>&1

    echo "[3] Prepare Juicer directory"
    mkdir -p data/juicer/${SAMPLE}/fastq

    ln -sf "$(pwd)/data/trimmed/${SAMPLE}_R1.trimmed.fastq.gz" \
        data/juicer/${SAMPLE}/fastq/${SAMPLE}_R1.fastq.gz

    ln -sf "$(pwd)/data/trimmed/${SAMPLE}_R2.trimmed.fastq.gz" \
        data/juicer/${SAMPLE}/fastq/${SAMPLE}_R2.fastq.gz

    echo "[4] Run Juicer"
    bash tools/juicer/scripts/juicer.sh \
        -D "$(pwd)/tools/juicer" \
        -d "$(pwd)/data/juicer/${SAMPLE}" \
        -g T2T_human \
        -z "$(pwd)/data/reference/T2T_human.fna" \
        -p "$(pwd)/data/reference/chrom.sizes" \
        -y "$(pwd)/data/reference/restriction_sites_DpnII.txt" \
        -s DpnII \
        -t ${THREADS}

    echo "[5] Copy final .hic"
    cp data/juicer/${SAMPLE}/aligned/inter_30.hic \
        results/hic/${SAMPLE}.inter_30.hic

    echo "Done: ${SAMPLE}"
done

echo "All samples processed successfully."
