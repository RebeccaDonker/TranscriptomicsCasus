#inladen packages 
library(microbiome)
library(Rsubread)
library(Rsamtools)
library(DESeq2)
library(KEGGREST)
library(pathview)
library(goseq)
library(geneLenDataBase)
library(org.Hs.eg.db)
library(GO.db)

library(EnhancedVolcano)

#working directory instellen
setwd("C:/Users/Donke/OneDrive/casus transcriptomics/")

#kijken of de juiste working directory is ingesteld
getwd()

#kijken wat erin staat
list.files()

#toegevoegd aan mijn working directory
buildindex(basename = 'refhuman genome', reference = 'GCF_000001405.40_GRCh38.p14_genomic.fna', memory = 4000, indexSplit = TRUE)

#alignen
align.sub1 <- align(index = "refhuman genome", readfile1 = "SRR4785819_1_subset40k.fastq", readfile2 = "SRR4785819_2_subset40k.fastq",  output_file = "norm1.BAM")
align.sub2 <- align(index = "refhuman genome", readfile1 = "SRR4785820_1_subset40k.fastq", readfile2 = "SRR4785820_2_subset40k.fastq",  output_file = "norm2.BAM")
align.sub3 <- align(index = "refhuman genome", readfile1 = "SRR4785828_1_subset40k.fastq", readfile2 = "SRR4785828_2_subset40k.fastq",  output_file = "norm3.BAM")
align.sub3 <- align(index = "refhuman genome", readfile1 = "SRR4785831_1_subset40k.fastq", readfile2 = "SRR4785831_2_subset40k.fastq",  output_file = "norm4.BAM")
align.sub4 <- align(index = "refhuman genome", readfile1 = "SRR4785979_1_subset40k.fastq", readfile2 = "SRR4785979_2_subset40k.fastq",  output_file = "RA1.BAM")
align.sub5 <- align(index = "refhuman genome", readfile1 = "SRR4785980_1_subset40k.fastq", readfile2 = "SRR4785980_2_subset40k.fastq",  output_file = "RA2.BAM")
align.sub6 <- align(index = "refhuman genome", readfile1 = "SRR4785986_1_subset40k.fastq", readfile2 = "SRR4785986_2_subset40k.fastq",  output_file = "RA3.BAM")
align.sub4 <- align(index = "refhuman genome", readfile1 = "SRR4785988_1_subset40k.fastq", readfile2 = "SRR4785988_2_subset40k.fastq",  output_file = "RA4.BAM")

# definieren van een vector met namen van BAM-bestanden. Elke BAM bevat reads van een RNA-seq-experiment (bijv. behandeld vs. controle).
allsamples <- c("norm1.BAM", "norm2.BAM", "norm3.BAM", "norm4.BAM", "RA1.BAM", "RA2.BAM", "RA3.BAM", "RA4.BAM")

#kijken of het is gelukt
list.files()

#count matrix creeren
count_matrix <- featureCounts(files = allsamples, annot.ext = "genomic.gtf", isPairedEnd = TRUE, isGTFAnnotationFile = TRUE, GTF.attrType = "gene_id", useMetaFeatures = TRUE)

head(count_matrix$annotation)
head(count_matrix$counts)

# Bekijk eerst de structuur van het object
str(count_matrix)

ncol(counts)

# Haal alleen de matrix met tellingen eruit
counts <- count_matrix$counts

colnames(counts) <- c("norm1", "norm2", "norm3", "norm4", "RA1", "RA2", "RA3", "RA4")


#opslaan
write.csv(counts, "bewerkt_countmatrix.csv")

head(counts)

#inladen gegeven count matrix
countmatrix <- read.table("count_matrix.txt")

countmatrix

#Behandelingstabel maken
treatment <- c("normal", "normal", "normal", "normal", "RA", "RA", "RA", "RA")

# Zet dit om naar een data.frame
treatment_table <- data.frame(treatment)

# Geef de juiste sample namen als rownames (zoals BAM-bestanden)
colnames(countmatrix) <- c("norm1", "norm2", "norm3", "norm4", "RA1", "RA2", "RA3", "RA4")

rownames(treatment_table) <- c("norm1", "norm2", "norm3", "norm4", "RA1", "RA2", "RA3", "RA4")

countmatrix <- round(as.matrix(countmatrix))

# Maak DESeqDataSet aan
dds <- DESeqDataSetFromMatrix(countData = countmatrix, colData = treatment_table, design = ~ treatment)

dds

# Voer analyse uit
dds <- DESeq(dds)
resultaten <- results(dds)

resultaten

# Resultaten opslaan in een bestand
#Bij het opslaan van je tabel kan je opnieuw je pad instellen met `setwd()` of het gehele pad waar je de tabel wilt opslaan opgeven in de code.

write.table(resultaten, file = 'ResultatenCasus.csv', row.names = TRUE, col.names = TRUE)

#Hoeveel genen zijn er écht veranderd? Hier tellen we hoeveel genen er significant op- of neer-gereguleerd zijn.
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)

#Welke genen springen eruit? Nu sorteren we het resultaat om te kijken naar de opvallendste genen:
hoogste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = TRUE), ]
laagste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = FALSE), ]
laagste_p_waarde <- resultaten[order(resultaten$padj, decreasing = FALSE), ]

hoogste_fold_change
laagste_fold_change
laagste_p_waarde

#Bekijk nu welke genen het belangrijkst zijn volgens de analyse.
head(laagste_p_waarde)

#volcano plot
EnhancedVolcano(resultaten, lab = rownames(resultaten), x = 'log2FoldChange', y = 'padj')

#andere opmaak
# Alternatieve plot zonder p-waarde cutoff (alle genen zichtbaar)
EnhancedVolcano(resultaten, lab = rownames(resultaten), x = 'log2FoldChange', y = 'padj', pCutoff = 0)

#GO Enrichment using goseq
# Vereiste libraries
library(goseq)
library(org.Hs.eg.db)
library(GO.db)

# 1. Laad DESeq2-resultaten
resultaten <- read.table("ResultatenCasus.csv", header = TRUE, row.names = 1)

# 2. Maak de DEG- en ALL-lijsten op basis van filtering
DEG1 <- rownames(resultaten[resultaten$padj < 0.05 & abs(resultaten$log2FoldChange) > 1, ])
ALL1 <- rownames(resultaten)

# 3. Zet SYMBOLS om naar ENSEMBL (voor GOseq)
DEG1_ens <- mapIds(org.Hs.eg.db, keys = DEG1, column = "ENSEMBL", keytype = "SYMBOL", multiVals = "first")
ALL1_ens <- mapIds(org.Hs.eg.db, keys = ALL1, column = "ENSEMBL", keytype = "SYMBOL", multiVals = "first")

# 4. Maak unieke vectors zonder NA's
DEG1_ens <- DEG1_ens[!is.na(DEG1_ens)]
ALL1_ens <- ALL1_ens[!is.na(ALL1_ens)]

# 5. Maak gene.vector
gene.vector <- as.integer(ALL1_ens %in% DEG1_ens)
names(gene.vector) <- ALL1_ens

# Controleer inhoud van gene.vector
table(gene.vector)

# Bereken nullmodel
pwf <- nullp(gene.vector, "hg38", "ensGene")

# 7. GO enrichment uitvoeren
GO.wall <- goseq(pwf, "hg38", "ensGene")

# 8. Filter op significantie
enriched.GO <- GO.wall$category[GO.wall$over_represented_pvalue < 0.05]

# 9. Print GO-termen met beschrijving naar bestand
capture.output(for(go in enriched.GO) {
  print(GOTERM[[go]])
  cat("--------------------------------------\n")
}, file = "SigGo.txt")


#visualiseren

pathview(
  gene.data = resultaten,
  pathway.id = "hsa05323",  
  species = "hsa",          
  gene.idtype = "SYMBOL",    
  limit = list(gene = 5)    
)