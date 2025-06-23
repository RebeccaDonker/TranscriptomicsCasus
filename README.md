# TranscriptomicsCasus

**inhoud Github**


**inleiding**

Reumatoïde artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door pijnlijke gewrichtsontstekingen en mogelijk destructieve boterosie. Wereldwijd treft RA naar schatting 0,1–2,0% van de bevolking, met uitschieters tot 6,8% bij bepaalde inheemse gemeenschappen. De oorzaak is nog grotendeels onbekend en ondanks therapeutische vooruitgang bestaat er geen genezing. Genetische en omgevingsfactoren spelen een rol in de variatie in prevalentie tussen en binnen landen [global prevalence](https://link.springer.com/article/10.1007/s00296-020-04731-0).. RA ontwikkelt zich via een meerdere jaren durende prodromale fase, vaak met immuunactiviteit in mucosale weefsels voorafgaand aan symptomen. [Management of Rheumatoid Arthritis](https://www.mdpi.com/2073-4409/10/11/2857) 


Transcriptomics biedt een krachtig middel om de moleculaire basis van reumatoïde artritis (RA) te ontrafelen. Door genexpressieprofielen van RA-patiënten te vergelijken met gezonde controles kunnen betrokken genen en biologische processen worden geïdentificeerd. De transcriptome het geheel aan mRNA-moleculen in een cel vormt hierbij de basis. Dankzij RNA-sequencing, dat microarrays grotendeels heeft vervangen, kunnen genexpressiepatronen nauwkeurig worden geanalyseerd [Transcriptomics](https://www.sciencedirect.com/science/article/pii/S1367593112001585) .In dit onderzoek worden synoviumbiopten van vier ACPA-positieve RA-patiënten vergeleken met vier ACPA-negatieve controles. Via RNA-seq en Gene Ontology-analyse wordt onderzocht welke genen afwijkend tot expressie komen en welke pathways mogelijk betrokken zijn bij RA. Deze aanpak kan een inzicht geven in ziekteprocessen.



---

**Methoden**

Voor dit onderzoek zijn synoviumbiopten verzameld van vier Reumatoïde Artritis (RA)-patiënten (ACPA-positief, >12 maanden gediagnosticeerd) en vier ACPA-negatieve controles. RNA werd geïsoleerd en omgezet naar cDNA. Sequencing vond plaats op een Illumina-platform (paired-end, 2×300 bp), waarbij ruwe .fastq-bestanden werden gegenereerd.


De reads zijn uitgelijnd op het humane referentiegenoom van [NCBI](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/)  De ruwe sequencingdata zijn uitgelijnd met behulp van de [Rsubread-package](https://bioconductor.org/packages/release/bioc/html/Rsubread.html) (versie 2.20.0). De resulterende .BAM-bestanden zijn gekwantificeerd met featureCounts, waarna een countmatrix is opgebouwd. Deze matrix werd ingelezen in R en verwerkt met [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) (versie 1.46.0) voor differentiële genexpressieanalyse. Genen met een aangepaste p-waarde < 0.05 werden als significant beschouwd.
Voor functionele interpretatie is een Gene Ontology (GO)-verrijkingsanalyse uitgevoerd met [goseq](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) (versie 1.58.0), waarbij genlengtebias is gecorrigeerd. Verrijkte GO-termen binnen de categorieën Biological Process (BP), Molecular Function (MF) en Cellular Component (CC) zijn geïdentificeerd met behulp van [GO.db](https://bioconductor.org/packages/release/data/annotation/html/GO.db.html) (versie 3.20.0) en [org.Hs.eg.db](https://bioconductor.org/packages/release/data/annotation/html/org.Hs.eg.db.html) (versie 3.20.0).




Daarnaast is een KEGG pathway-analyse uitgevoerd met [pathvieuw](https://bioconductor.org/packages/release/bioc/html/pathview.html) (versie 1.46.0) en [KEGGREST](https://bioconductor.org/packages/release/bioc/html/KEGGREST.html) (versie 1.46.0), waarbij log2FoldChange-waarden zijn geprojecteerd op relevante humane pathways.

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


