#inladen packages 

library(phyloseq)
library(Biostrings)
library(ggplot2)
library(dada2)
library(vegan)
library(dplyr)
library(ANCOMBC)
library(microbiome)
library(Rsubread)
library(Rsamtools)
library(DESeq2)
library(KEGGREST)
library(pathview)
library(goseq)
library(geneLenDataBase)
library(org.Hs.eg.db)
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
if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
  BiocManager::install("EnhancedVolcano")
}
library(EnhancedVolcano)


EnhancedVolcano(resultaten, lab = rownames(resultaten), x = 'log2FoldChange', y = 'padj')

#andere opmaak
# Alternatieve plot zonder p-waarde cutoff (alle genen zichtbaar)
EnhancedVolcano(resultaten, lab = rownames(resultaten), x = 'log2FoldChange', y = 'padj', pCutoff = 0)

#go ding maken 
#downloaden
BiocManager::install("goseq")
BiocManager::install("geneLenDataBase")
BiocManager::install("org.Hs.eg.db")

#inladen
library(goseq)
library(geneLenDataBase)
library(org.Hs.eg.db)

write.table(rownames(resultaten), file = "ALL.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Selecteer significante genen
DEG <- resultaten[resultaten$padj < 0.05 & !is.na(resultaten$padj), ]

# Schrijf alleen de gen-namen weg
write.table(rownames(DEG), file = "DEG.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

DEG <- read.table("DEG.txt", header = FALSE)
ALL <- read.table("ALL.txt", header = FALSE)

#naar vectoren veranderen
class(DEG)
DEG.vector <- c(t(DEG))
ALL.vector<-c(t(ALL))

#Construeer een nieuwe vector die een 0 toevoegt naast elk gen dat niet in onze DEG-lijst staat en een 1 naast elk gen dat wél in onze DEG-lijst staat.
gene.vector=as.integer(ALL.vector%in%DEG.vector)
names(gene.vector)=ALL.vector 

#lets explore this new vector a bit
head(gene.vector)
tail(gene.vector)


#Weeg de genvector met de lengtes van onze genen. Deze lengte-informatie komt uit een ander pakket, waarbij we de exacte naam van ons genoom en de gen-ID's moeten opgeven.
pwf = nullp(gene.vector, "hg38", "geneSymbol")

#if (!requireNamespace("TxDb.Hsapiens.UCSC.hg38.knownGene", quietly = TRUE)) {
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
}
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(org.Hs.eg.db)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

# Genlengtes ophalen (som van exons per gen)
exons_gene <- exonsBy(txdb, by = "gene")
gene_lengths <- sum(width(reduce(exons_gene)))

# Names zijn Entrez IDs, je gen vector heeft waarschijnlijk geneSymbols, dus vertaal geneSymbols naar Entrez IDs
gene_symbols <- names(gene.vector)

# Vertaling naar Entrez IDs
symbol2entrez <- mapIds(org.Hs.eg.db, keys=gene_symbols, column="ENTREZID", keytype="SYMBOL", multiVals="first")

# Match de lengtes aan je gen vector op Entrez ID
lengths_vector <- gene_lengths[symbol2entrez]

# Maak bias.data aan met dezelfde volgorde als gene.vector
bias_data <- lengths_vector[match(symbol2entrez, names(gene_lengths))]

# Vervang NA door gemiddelde lengte of iets anders (optioneel)
bias_data[is.na(bias_data)] <- mean(bias_data, na.rm=TRUE)

# Nu run je nullp met bias.data
pwf <- nullp(gene.vector, bias.data=bias_data)

GO.wall = goseq(pwf, genome = "hg38", id = "geneSymbol", test.cats = c("GO:BP", "GO:MF", "GO:CC"))

# Hoeveel verrijkte GO-termen zijn er?
class(GO.wall)
head(GO.wall)
nrow(GO.wall)

# Pas multiple testing correctie toe (FDR)
GO.wall$padj <- p.adjust(GO.wall$over_represented_pvalue, method = "BH")

# Selecteer alleen significant verrijkte GO-termen op basis van aangepaste p-waarde
enriched.GO <- GO.wall$category[GO.wall$padj < 0.05]

# Hoeveel significante GO-termen?
class(enriched.GO)
head(enriched.GO)
length(enriched.GO)

entrez_ids <- mapIds(org.Hs.eg.db, keys = rownames(resultaten), column = "ENTREZID", keytype = "SYMBOL",multiVals = "first")
entrez_ids

# Voeg Entrez ID toe aan resultaten voor overzicht
resultaten$entrez <- entrez_ids

# === 3. Maak log2FoldChange-vector met Entrez als namen (voor pathview) ===
gene_vector <- resultaten$log2FoldChange
names(gene_vector) <- entrez_ids
gene_vector <- gene_vector[!is.na(names(gene_vector))]  # verwijder NA's

# === 4. Run pathview met humane pathway (voorbeeld: hsa04110 = celcyclus) ===
pathview(gene.data = gene_vector, pathway.id = "hsa04110",species = "hsa",gene.idtype = "ENTREZ", limit = list(gene = 5) , out.suffix = "cell_cycle_human")








