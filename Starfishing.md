# Identifying Pyricularia Starhsips using Starfish

## 1. Rename contigs in gff file to be compatible with Starfish:
```bash
sed 's/Chr/Arcadia_Chr/' Arcadia2.gff3 > Arcadia2_modified.gff3
```
## 2. Change gff Name= feature format to be compatible with Starfish:
```bash
awk '$3 ~ /mRNA/' Arcadia2_modified.gff | sed 's/Name=.*Chr/Name=Chr/' | sed 's/-processed-gene-/_/g' | sed 's/-mRNA-1;_AED.*//' | sed 's/-augustus-gene-/_/g' | sed 's/-snap-gene-/_/g' > CD156_processed.gff
```
