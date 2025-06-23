# TranscriptomicsCasus

**inhoud Github**


**inleiding**

Reumatoïde artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door pijnlijke gewrichtsontstekingen en mogelijk destructieve boterosie. Wereldwijd treft RA naar schatting 0,1–2,0% van de bevolking, met uitschieters tot 6,8% bij bepaalde inheemse gemeenschappen. De oorzaak is nog grotendeels onbekend en ondanks therapeutische vooruitgang bestaat er geen genezing. Genetische en omgevingsfactoren spelen een rol in de variatie in prevalentie tussen en binnen landen(Almutairi et al., 2021). RA ontwikkelt zich via een meerdere jaren durende prodromale fase, vaak met immuunactiviteit in mucosale weefsels voorafgaand aan symptomen [global prevalence](https://link.springer.com/article/10.1007/s00296-020-04731-0).
Transcriptomics biedt een krachtig middel om de moleculaire basis van reumatoïde artritis (RA) te ontrafelen. Door genexpressieprofielen van RA-patiënten te vergelijken met gezonde controles kunnen betrokken genen en biologische processen worden geïdentificeerd. De transcriptome het geheel aan mRNA-moleculen in een cel vormt hierbij de basis. Dankzij RNA-sequencing, dat microarrays grotendeels heeft vervangen, kunnen genexpressiepatronen nauwkeurig worden geanalyseerd [Transcriptomics](https://www.sciencedirect.com/science/article/pii/S1367593112001585) .In dit onderzoek worden synoviumbiopten van vier ACPA-positieve RA-patiënten vergeleken met vier ACPA-negatieve controles. Via RNA-seq en Gene Ontology-analyse wordt onderzocht welke genen afwijkend tot expressie komen en welke pathways mogelijk betrokken zijn bij RA. Deze aanpak kan een inzicht geven in ziekteprocessen.



---

**Methoden**

Voor dit onderzoek zijn synoviumbiopten verzameld van vier Reumatoïde Artritis (RA)-patiënten (ACPA-positief, >12 maanden gediagnosticeerd) en vier ACPA-negatieve controles. RNA werd geïsoleerd en omgezet naar cDNA. Sequencing vond plaats op een Illumina-platform (paired-end, 2×300 bp), waarbij ruwe .fastq-bestanden werden gegenereerd.
De reads zijn uitgelijnd op het humane referentiegenoom (hg38) met behulp van de Rsubread-package. De resulterende .BAM-bestanden zijn gekwantificeerd met featureCounts, waarna een countmatrix werd opgebouwd. Deze matrix werd ingelezen in R en verwerkt met DESeq2 voor differentiële genexpressieanalyse. Genen met een aangepaste p-waarde < 0.05 werden als significant beschouwd.
Voor functionele interpretatie is een Gene Ontology (GO)-verrijkingsanalyse uitgevoerd met goseq, waarbij genlengtebias is gecorrigeerd. Verrijkte GO-termen binnen de categorieën Biological Process (BP), Molecular Function (MF) en Cellular Component (CC) zijn geïdentificeerd. Daarnaast is een KEGG pathway-analyse uitgevoerd met pathview, waarbij log2FoldChange-waarden zijn geprojecteerd op relevante humane pathways.
Alle analyses zijn uitgevoerd in R met de packages (Accessing the KEGG REST API, n.d.; An Introduction to Rsamtools, n.d.; Analyzing RNA-Seq Data with DESeq2, n.d.; Bioconductor - DESeq2, n.d.; Bioconductor - GO.Db, n.d.; Bioconductor - Org.Hs.Eg.Db, n.d.; EnhancedVolcano: Publication-Ready Volcano Plots with Enhanced Colouring and Labeling, n.d.; Package “geneLenDataBase” Title Lengths of MRNA Transcripts for a Number of Genomes, 2025; Package “Microbiome,” 2025; Luo, 2025; Shi & Liao, 2025)

---

**Resultaten**

De RNA-sequencing leidde tot hoogwaardige reads die succesvol werden uitgelijnd op het referentiegenoom, wat terug te zien is in de mapping-statistieken. De differentiële expressieanalyse via DESeq2 resulteerde in een dataset van 29.407 geanalyseerde genen. Met een padj < 0.05 en absolute log2 fold change > 1 werden meerdere genen geïdentificeerd die significant verschillend tot expressie kwamen tussen RA-patiënten en controles.
De volcano plot toont deze verschillen, waarbij significante genen (rood) zowel een sterke verandering in expressie als statistische betrouwbaarheid vertonen. Opvallende genen waren onder andere ANKRD30BL, MT-ND6, BCL2A1 en CD226, die mogelijk een rol spelen in het ziekteproces en verdere functionele analyse verdienen.
De GO-verrijkingsanalyse (bestand SigGo.txt) liet zien dat significante genen betrokken zijn bij immuunresponsen, signaaltransductie, apoptose, transcriptieregulatie en eiwittransport. Deze processen zijn bekend als belangrijke aspecten van RA-pathologie.
De KEGG pathway-analyse met pathview benadrukte verhoogde expressie van ontstekingsmediatoren zoals TNFα, IL-6, IL-1β en RANKL, en toonde activering van immuuncellen (T- en B-cellen, macrofagen) en osteoclasten die bijdragen aan botresorptie en gewrichtsschade (hsa05323). Deze bevindingen bevestigen de complexiteit van RA en onderstrepen mogelijke therapeutische targets. (hsa05323.pathview)

---

**Conclusie**

Dit onderzoek toont aan dat RNA-sequencing en bio-informatica analyses inzicht geven in de moleculaire basis van Reumatoïde Artritis. De identificatie van significant veranderde genen en verrijkte biologische processen bevestigt het ontstekingskarakter van RA en wijst op belangrijke immuunroutes en celtypen die betrokken zijn bij ziekteprogressie. Het gebruik van GO- en KEGG-analyse helpt deze genen in een biologisch context te plaatsen en mogelijke aangrijpingspunten voor therapie te identificeren.
Voor toekomstig onderzoek is het aan te raden de bevindingen te valideren in grotere patiëntengroepen en functioneel onderzoek te doen naar specifieke genen zoals ANKRD30BL en BCL2A1. Bovendien kan integratie met proteomics en klinische data leiden tot een meer omvattend begrip van RA. Tenslotte is het belangrijk om data management en scriptdocumentatie goed te borgen, zodat onderzoeksresultaten reproduceerbaar en betrouwbaar blijven.

---

**beheer**


