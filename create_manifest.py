from pathlib import Path
import csv

# Project main directory
PROJECT = Path(__file__).resolve().parent.parent

# Input and output directories
INPUT_DIR = PROJECT / "results" / "fastp"
OUTPUT_DIR = PROJECT / "results" / "files_for_qiime2" / "manifest.tsv"

# Finding all forward reads (the R1 ones)
forward_files = sorted(INPUT_DIR.glob("*_R1_clean.fastq.gz"))

# Creating the output directory
OUTPUT_DIR.parent.mkdir(parents=True, exist_ok=True)

# Writing the whole table
with open(OUTPUT_DIR, "w", newline="\n") as manifest:
    writer = csv.writer(manifest, delimiter="\t")
    # Columns headers
    writer.writerow(["sample-id", "absolute-filepath", "direction"])

    for ff in forward_files:
        # Sample name
        sample = ff.name.replace("_R1_clean.fastq.gz", "")

        # Find the corresponding reverse read (the R2 ones)
        rf = INPUT_DIR / f"{sample}_R2_clean.fastq.gz"

        if not rf.exists():
            raise FileNotFoundError(f"Reverse read not found for sample {sample}: {rf}")

        writer.writerow([sample, ff.resolve(), "forward"])
        writer.writerow([sample, ff.resolve(), "reverse"])

print(f"Manifest created: {OUTPUT_DIR}")
