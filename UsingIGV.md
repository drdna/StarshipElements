# Visualizing Starship flank regions in IGV
1. Open IGV
![IGV](/screenshots/IGV.png)
3. go the "Genomes" menu and select "Load Genome from File" (note: once you have opened a genome one time, it will be available under the drag down menu on the top left).
![LoadGenome](/screenshots/LoadGenome.png)
4. Navigate to desired genome assembly file and select "Open"
5. Load the associated starship flanks GFF file by selecting the "File -> Load from File" option."
![LoadGFF](/screenshots/LoadGFF.png)
6. Select the GFF file that has the same prefix as the loaded genome file (here the loaded genome is B71v2sh_nh.fasta and the selected GFF file is B71v2sh_nh_Starship_flanks_noclean_recolored.gff).
![SelectGFF](/screenshots/SelectGFF.png)
7. Select the first chromosome to analyze by clicking on its name in the navigation bar (or use the "All" drag-down menu option in the top panel).
8. Expand the "Starship Flanks" track by right-clicking (control-clicking) on the track name and select "Expanded."
![SelectExpand](/screenshots/SelectExpand.png)
9. Now you should be able to see all of the relevant features on the chromosome. Here, we are only interested in exploring features surrounding starship flanks and these are labeled with key starship identifiers (GenomeID_chromosome_start_end). These are shown with arrows in the figure below:
![FindFeatures2](/screenshots/FindFeatures2.png)
10. Zoom in on each feature to explore chromosome content and structure surrounding starhsip flanking sequences (these are sequences known to flank starship insertions in other genomes but which may, or may not, flank a starship insertion in the genome currently being queried). Zoom by clicking in the navigation toolbar and dragging to elect the end of the desired zoom area:
![DragNZoom](/screenshots/DragNZoom.png)
11. This will gradually zoom in on the selected feature but the names of all features will not be visible until a sufficient zoom level is reached. Note in the figure below that Zoom #1 shows alignemnts for two flanking sequences (blue boxes) but only one label is visible:
![Zoom1](/screenshots/Zoom1.png) 
13. Repeat click and drag operations until the names of all features are clearly visible:
14. ![FullZoom](/screenshots/FullZoom.png)
15. Once the structure of the (empty) starship locus has been recorded, you can Zoom out to the whole chromosome view by clicking on the Zoom bar next to the '-' symbol:
![ZoomOut](/screenshots/ZoomOut.png)
