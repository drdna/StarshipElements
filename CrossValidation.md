# Compare STARFISH output with manual annotations
1. Inspect the [Starfish insert bed file](/data/PyStar.insert.bed) and cross-reference with our list of manually annotated elements. Each element is bounded by an "up" flank and a "down" flank. Use the relevant coordinates to check if the starship has the same coordinates as one identified previously by the team. In the following example,

![insert3.png](/data/insert3.png)

the element is between positions 5,349,244 and 5,449,526 on chromosome 1 of Arcadia2 and is in the reverse orientation. 

2. Edit the [spreadsheet](https://luky.sharepoint.com/:x:/r/sites/MANUSCRIPTs791/_layouts/15/Doc.aspx?sourcedoc=%7BB57224E1-CBC8-4399-9C2E-5D714591317C%7D&file=Starship_validation.xlsx&action=default&mobileredirect=true) to record how accurately STARFISH predicted each element. The family to which each element belongs can be found in the [PoCaptainFamilies.txt](/data/PoCaptainFamilies.txt) file

# Characterizing new elements identified by Starfish
1. Open IGV, load the appropriate reference genome and relevant annotation tracks using these basic [instructions](https://github.com/drdna/StarshipElements/blob/main/UsingIGV.md). Standard annotation tracks that need to be included are:
a) Starships.RefGenome.paf (in this example, Starships.Arcadia2.paf). This shows where the known starships are located in the reference genome.
b) [PyStar.elements.bed](/data/PyStar.elements.bed). This shows the positions of captains, terminal inverted repeats and direct repeats identified by STARFISH. If we look at the element on Arcadia2 chromosome 1 between positions 5,349,244 and 5,449,526, we can see that there is no corresponding element in the Starships.Arcadia2.paf track:

![NewStarship.png](/data/NewStarship.png)

3. To refine the insertion positions of the new starship identified by STARFISH, we need to align the reference genome against the genome that was used to identify the starship insertion. In the above example, we can see that the insert was identified by aligning the Arcadia2 genome against B71.
4. Create an Arcadia2 x B71 alignment using minimap2:
```bash
minimap2 B71v2sh.fasta Arcadia2.fasta -o Arcadia2.B71v2sh.paf
```
5. Load the Arcadia2.B71v2sh.paf into IGV, right click the track and select expanded view.
6. Use click and drag to zoom in to the left insertion boundary:

![LeftBorder.png](/data/LeftBorder.png)

7. Manually record the 10 nucleotides immediately flanking the starship insertion. Here, the flanking sequence is ACCGTGGGCC and the Starship border is AATATCGCTG.

8. Zoom out until you see the right border and then Zoom in to see the nucleotide sequences around that border:

![RightBorder.png](/data/RightBorder.png)

9. Manually record the 10 nucleotides that define the starship border. Here, the flanking sequence is TCGTGTCAAT and the Starship border is ACTCCACAAC. Therefore, we cannot see an obvious inverted repeat at the starship border, nor can we see an obvious direct repeat immediately flanking the insertion site.

# Characterize insertion targets of novel starship elements found by STARFISH
1. Copy about 200 bp of sequence from each flank of the insertion site by zooming in on one flank so that one can see about 200 bp of flanking sequence (use the scale as a guide). Click on the Define Region tool:

![Garbage3.png](/data/Garbage3.png)

2. Click in the regions marked with plus symbols, making sure that the one side coincides precisely with the element border (zoom in further, if necessary).

![SelectRegion.png](/data/SelectRegion.png)

3. Option+click on the red bar that appears and select Copy Sequence

![CopySequence.png](/data/CopySequence.png)

4. Open the Terminal program (Mac) or Powershell (PC) and create a text document named NovelStarshipFlanks.fasta:
```bash
nano NovelStarshipFlanks.fasta
```
5. Name the sequence, using fasta header format and paste in the copied sequence on the next line:

![NanoDoc.png](/data/NanoDoc.png)

6. Close the document using ctrl-x, type "y" to accept the filename and hit return to save the document. Next, create a "RF" sequence entry for 200 bp flanking the right border of the element. Continue adding new sequencxe entries to this file forflanking sequencxe surrounding each novel starship in the current genome under study.

