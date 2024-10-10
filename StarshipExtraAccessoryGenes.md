# Identification of Interesting genes in other starship copies
1. BLAST fgenesh proteins against the 211 B71 predicted proteins
```bash
blastp -query fgenesh.pep -subject 211B71.pep -evalue 1e-5 -outfmt '6 qseqid sseqid qlen length' | awk '$4 > $3*0.8' . myMatchingProteins.pep
```
3. Identify proteins that show alignment across 80% of their lengths
4. Create a list of matching proteins
5. Create table of annoation data (protein ID, motifs and functions) for the proteins found in other starship copies
6. Filter the table to remove those proteins that shiwed alignment to the B71 
7. 
8. 
