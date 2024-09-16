# Compare STARFISH output with manual annotations
1. Inspect the [Starfish insert bed file](/data/PyStar.insert.bed) and cross-reference with list of manually annotated elements. Each element is bounded by an "up" flank and a "down" flank. Use the relevant coordinates to check if the starship has the same coordinates as one identified previously by the team. In the following example,

![insert3.png](/data/insert3.png)

the element is between positions 5,349,244 and 5,449,526 on chromosome 1 of Arcadia2 and is in the reverse orientation. 
2. Edit the [spreadsheet](https://luky.sharepoint.com/:x:/r/sites/MANUSCRIPTs791/_layouts/15/Doc.aspx?sourcedoc=%7BB57224E1-CBC8-4399-9C2E-5D714591317C%7D&file=Starship_validation.xlsx&action=default&mobileredirect=true) to record how accurately STARFISH predicted each element.

# Characterizing new elements identified by Starfish
1. Open IGV, load the appropriate reference genome and relevant annotation tracks using these basic [instructions](https://github.com/drdna/StarshipElements/blob/main/UsingIGV.md). Standard annotation tracks that need to be included are:
a) Starship_alignments.gff. This shows where the known starships are located in the reference genome.
b) PyStar.element.bed. This shows the positions of captains, terminal inverted repeats and direct repeats identified by STARFISH.
2. To refine the insertion positions, we need to align the refenxce genome against the genome that was used to identify the starship insertion. In the above example, we can see that the insert was identified by aligning the Arcadia2 genome against B71.
3. Create an Arcadia2 x B71 alignment using minimap2:
```bash
minimap2 B71v2sh.fasta Arcadia2.fasta -o Arcadia2.B71v2sh.paf
```
4. Load the Arcadia2.B71v2sh.paf into IGV, right click the track and select expanded view.
5. Use click and drag to zoom in to one of the insertion boundaries:


6. Manually record the 10 nucleotides immediately flanking the starship insertion. Here, they are:

8. manually record the 10 nucleotide that define the starship border. Here, they are: 
