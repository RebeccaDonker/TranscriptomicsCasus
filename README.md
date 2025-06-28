# TranscriptomicsCasus

**📄 Inhoudsopgave Githubpagina**

**Rscript/**

transcriptomics.casus2.R – R-script voor transcriptomicsanalyse

**bronnen/**

tweede versie transcriptomics bronnen.docx – Gebruikte literatuur en referenties

**ersultaten**

resultaten en analyses

**DataStewardshipRebeccaDonker.md**

Document over databeheer en verantwoording

**GitHub_usageRebeccaDonker.md**

Uitleg over het gebruik van GitHub binnen dit project

**README.md**

Algemene projectinformatie en toelichting op de mappenstructuur

---


**🧾inleiding**

Reumatoïde artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door pijnlijke gewrichtsontstekingen en mogelijk destructieve boterosie. Wereldwijd treft RA naar schatting 0,1–2,0% van de bevolking, met uitschieters tot 6,8% bij bepaalde inheemse gemeenschappen. De oorzaak is nog grotendeels onbekend en ondanks therapeutische vooruitgang bestaat er geen genezing. Genetische en omgevingsfactoren spelen een rol in de variatie in prevalentie tussen en binnen landen [global prevalence](https://link.springer.com/article/10.1007/s00296-020-04731-0).. RA ontwikkelt zich via een meerdere jaren durende prodromale fase, vaak met immuunactiviteit in mucosale weefsels voorafgaand aan symptomen. [Management of Rheumatoid Arthritis](https://www.mdpi.com/2073-4409/10/11/2857) 


Transcriptomics biedt een krachtig middel om de moleculaire basis van reumatoïde artritis (RA) te ontrafelen. Door genexpressieprofielen van RA-patiënten te vergelijken met gezonde controles kunnen betrokken genen en biologische processen worden geïdentificeerd. De transcriptome het geheel aan mRNA-moleculen in een cel vormt hierbij de basis. Dankzij RNA-sequencing, dat microarrays grotendeels heeft vervangen, kunnen genexpressiepatronen nauwkeurig worden geanalyseerd [Transcriptomics](https://www.sciencedirect.com/science/article/pii/S1367593112001585) .In dit onderzoek worden synoviumbiopten van vier ACPA-positieve RA-patiënten vergeleken met vier ACPA-negatieve controles. Via RNA-seq en Gene Ontology-analyse wordt onderzocht welke genen afwijkend tot expressie komen en welke pathways mogelijk betrokken zijn bij RA. Deze aanpak kan een inzicht geven in ziekteprocessen.



---

**⚙️Methoden**

Voor dit onderzoek zijn synoviumbiopten verzameld van vier Reumatoïde Artritis (RA)-patiënten (ACPA-positief, >12 maanden gediagnosticeerd) en vier ACPA-negatieve controles. RNA werd geïsoleerd en omgezet naar cDNA. Sequencing vond plaats op een Illumina-platform (paired-end, 2×300 bp), waarbij ruwe .fastq-bestanden werden gegenereerd.


De reads zijn uitgelijnd op het humane referentiegenoom van [NCBI](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/)  De ruwe sequencingdata zijn uitgelijnd met behulp van de [Rsubread-package](https://bioconductor.org/packages/release/bioc/html/Rsubread.html) (versie 2.20.0). De resulterende .BAM-bestanden zijn gekwantificeerd met featureCounts, waarna een countmatrix is opgebouwd. Deze matrix werd ingelezen in R en verwerkt met [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) (versie 1.46.0) voor differentiële genexpressieanalyse. Genen met een aangepaste p-waarde < 0.05 werden als significant beschouwd.
Voor functionele interpretatie is een Gene Ontology (GO)-verrijkingsanalyse uitgevoerd met [goseq](https://bioconductor.org/packages/release/bioc/html/DESeq2.html) (versie 1.58.0), waarbij genlengtebias is gecorrigeerd. Verrijkte GO-termen binnen de categorieën Biological Process (BP), Molecular Function (MF) en Cellular Component (CC) zijn geïdentificeerd met behulp van [GO.db](https://bioconductor.org/packages/release/data/annotation/html/GO.db.html) (versie 3.20.0) en [org.Hs.eg.db](https://bioconductor.org/packages/release/data/annotation/html/org.Hs.eg.db.html) (versie 3.20.0).




Daarnaast is een KEGG pathway-analyse uitgevoerd met [pathvieuw](https://bioconductor.org/packages/release/bioc/html/pathview.html) (versie 1.46.0) en [KEGGREST](https://bioconductor.org/packages/release/bioc/html/KEGGREST.html) (versie 1.46.0), waarbij log2FoldChange-waarden zijn geprojecteerd op relevante humane pathways.

---


**Resultaten**

**🧬 Kwaliteit van RNA-sequencing en mapping**
De RNA-sequencing leverde hoogwaardige reads op die succesvol werden uitgelijnd op het humane referentiegenoom, wat bevestigd werd door de mapping-statistieken.


**📊 Differentiële genexpressieanalyse**
De differentiële genexpressieanalyse via DESeq2 resulteerde in een dataset van 29.407 geanalyseerde genen. Met een aangepaste p-waarde kleiner dan 0.05 en een absolute log2 fold change groter dan 1 werden meerdere genen geïdentificeerd die significant verschillend tot expressie kwamen tussen RA-patiënten en gezonde controles.


**🌋 Visualisatie: Volcano plot**
De [volcano plot](https://github.com/RebeccaDonker/TranscriptomicsCasus/blob/main/resultaten/volcano%20plot.png) toont deze verschillen, waarbij significante genen (rood) zowel een sterke verandering in expressie als statistische betrouwbaarheid vertonen. Opvallende genen waren onder andere ANKRD30BL, MT-ND6, BCL2A1 en CD226, die mogelijk een rol spelen in het ziekteproces en verdere functionele analyse verdienen.

**🧠 GO-verrijkingsanalyse**
De GO-verrijkingsanalyse [SigGo](https://github.com/RebeccaDonker/TranscriptomicsCasus/blob/main/resultaten/SigGo.txt) liet zien dat de significant gereguleerde genen betrokken zijn bij immuunresponsen, signaaltransductie, apoptose, transcriptieregulatie en eiwittransport. Deze processen zijn bekend als belangrijke aspecten van de RA-pathologie en ondersteunen de relevantie van de gevonden genen binnen het ziektebeeld.

**🧭 KEGG pathway-analyse**
De KEGG pathway-analyse met pathview benadrukte verhoogde expressie van ontstekingsmediatoren zoals TNFα, IL-6, IL-1β en RANKL. Daarnaast werd activering van immuuncellen zoals T- en B-cellen, macrofagen en osteoclasten waargenomen, die bijdragen aan botresorptie en gewrichtsschade. Deze bevindingen, zichtbaar in [pathway hsa05323](https://github.com/RebeccaDonker/TranscriptomicsCasus/blob/main/resultaten/hsa05323.pathview.png), onderstrepen de complexiteit van RA en wijzen op mogelijke therapeutische aangrijpingspunten


---

**Conclusie**


Reumatoïde artritis (RA) is een complexe auto-immuunziekte waarbij het afweersysteem het eigen lichaamsweefsel aanvalt. In dit onderzoek is gekeken naar genexpressieverschillen tussen RA-patiënten en gezonde controles om beter te begrijpen welke processen een rol spelen in de ziekte. Uit de RNA-sequencing kwamen meerdere genen naar voren die significant anders tot expressie kwamen, waaronder genen die betrokken zijn bij ontstekingsprocessen, zoals TNFα, IL-6 en RANKL. Deze resultaten sluiten goed aan bij wat al bekend is over RA, namelijk dat ontstekingsmediatoren en immuuncellen een centrale rol spelen bij de schade aan gewrichten.

Ook bleek uit de GO- en KEGG-analyses dat de veranderde genexpressie vooral te maken had met immuunactivatie, signaaloverdracht en celregulatie. Deze processen passen bij het ziektebeeld van RA. De resultaten geven dus een waardevol inzicht in mogelijke moleculaire mechanismen achter RA.

Toch moet er rekening worden gehouden met de kleine steekproefomvang van dit onderzoek. Met slechts vier patiënten en vier controles zijn de resultaten beperkt generaliseerbaar. Voor vervolgonderzoek zou het daarom goed zijn om met grotere groepen te werken en eventueel functionele experimenten toe te voegen om de rol van specifieke genen verder te onderzoeken.


---

**beheer**


Voor het waarborgen van reproduceerbaarheid, transparantie en datakwaliteit binnen dit project zijn aanvullende documenten opgesteld waarin het beheer van scripts en onderzoeksgegevens uitgebreid wordt toegelicht. In het document GitHub voor onderzoeksbeheer wordt beschreven hoe versiebeheer is toegepast met Git en GitHub, inclusief de opbouw van de repository, het gebruik van commits en branches, en het onderscheid tussen de eerste en tweede versie van het analyse-script.


Daarnaast is in het document Data Stewardship in dit project uiteengezet hoe ik als data steward verantwoordelijk was voor het organiseren, beveiligen en documenteren van de onderzoeksgegevens. Hierin wordt onder meer toegelicht hoe datakwaliteit, privacy en toegankelijkheid zijn gewaarborgd, en hoe deze principes zijn toegepast binnen de context van dit transcriptomicsproject.

**bronnen**


Bij bronnen is een word document opgesteld met alle gebruikte bronnen. ook zijn alle handeleidingen zijn ook terug te vinden
 



