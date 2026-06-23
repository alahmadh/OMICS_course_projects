from pathlib import Path
import re

inp = Path("data/reference/T2T_human.fna")
out = Path("data/reference/T2T_human.renamed.fna")
map_out = Path("data/reference/T2T_human.rename_chroms.tsv")

mapping = {}

with inp.open() as fin, out.open("w") as fout, map_out.open("w") as m:
    m.write("old_id\tnew_id\tdescription\n")
    for line in fin:
        if line.startswith(">"):
            old_id = line[1:].split()[0]
            desc = line.strip()[1:]

            mt = re.search(r"chromosome ([0-9XYM]+)", desc)
            if mt:
                chrom = mt.group(1)
                new_id = "chrM" if chrom == "M" else f"chr{chrom}"
            else:
                new_id = old_id

            mapping[old_id] = new_id
            m.write(f"{old_id}\t{new_id}\t{desc}\n")
            fout.write(f">{new_id}\n")
        else:
            fout.write(line)

inp.rename("data/reference/T2T_human.original_ncbi.fna")
out.rename("data/reference/T2T_human.fna")
print("Renamed FASTA headers to chr-style names.")
