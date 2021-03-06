library(RColorBrewer)
library(viridis)

libprop_SF_and_male <- libprop[libprop$condition %in% c("male","SF") & libprop$keep == 1,]
libprop_all <- libprop[libprop$keep == 1,]

tpm_male_SF <- subset(tpm_all_with_annotation,select=c(row.names(libprop_SF_and_male),colnames(gene_annotations)))
row.names(tpm_male_SF) <- tpm_male_SF$internal.gene_id
write.csv(tpm_male_SF,'TPM_male_SF.csv')

tpm_all_for_CSV <- subset(tpm_all_with_annotation,select=c(row.names(libprop_all),colnames(gene_annotations)))
row.names(tpm_all_for_CSV) <- tpm_all_for_CSV$internal.gene_id
write.csv(tpm_all_for_CSV,'TPM_all.csv')


### list of tissues of interest for the annotation plots

tissue_list <- c("Fe_Ov_SF","Fe_Pa_SF","Fe_Os_SF","Fe_Br_SF","Fe_An_SF","Fe_Rs_SF","Fe_FL_SF","Fe_ML_SF","FE_HL_SF","Fe_At_SF","Ma_Br","Ma_An","Ma_Rs","Ma_FL","Ma_ML","Ma_HL","Ma_At")


### create appropriate empty vectors for tissue means and medians

if(exists('compiled_means')) {rm(compiled_means)}
if(exists('compiled_medians')) {rm(compiled_medians)}

compiled_means <- gene_annotations
compiled_medians <- gene_annotations

### cycle through tissues and add means/medians to appropriate vectors

library(plyr)

for (tissue in tissue_list)
{
  tissue_select <- subset_TPM(tissue,tpm_male_SF)
  
  compiled_means <- compiled_means[ order(row.names(compiled_means)), ]
  compiled_medians <- compiled_medians[ order(row.names(compiled_medians)), ]
  tissue_select <- tissue_select[ order(row.names(tissue_select)), ]
  
  compiled_means$"temp_mean" <- tissue_select$mean
  compiled_medians$"temp_median" <- tissue_select$median
  
  names(compiled_means)[names(compiled_means)=="temp_mean"] <- tissue
  names(compiled_medians)[names(compiled_medians)=="temp_median"] <- tissue
  }


genefamily_heatmap <- function(genefam,tpmMat,fname,maxTPM) {
 
  pdf(file=fname,width=8)
  
  family_subset <- tpmMat[tpmMat$gene.family %in% genefam,]
#  row.names(family_subset) <- family_subset$display.name
  
  disp_name <- paste(family_subset$vectorbase.RU,family_subset$display.name,sep="-")
  family_subset <- subset(family_subset,select=tissue_list)
  column_labels <- c("Ovaries","Palp","Proboscis","Brain","Antenna","Rostrum","Forelegs","Midlegs","Hindlegs","Abdominal tip","Brain","Antenna","Rostrum","Forelegs","Midlegs","Hindlegs","Abdominal tip")
  heatmap.2(log10(as.matrix(family_subset)+1),dendrogram="none",Colv=FALSE,sepwidth=c(.5,.5),
            trace="none",labCol=column_labels,srtCol=45,density.info="none",labRow=disp_name,
            key.xlab="Log10(TPM+1)",key.title=NA,
            breaks= seq(0,maxTPM,length.out=256),
            col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255)
           # col = colorRampPalette(rev(brewer.pal(9,"Blues")))(255) 
           # col = rev(viridis(100))
           )
  dev.off()
}

manual_heatmap <- function(genefam,tpmMat,fname,maxTPM) {
  
  pdf(file=fname,width=8)
  
  family_subset <- tpmMat[tpmMat$internal.gene_id %in% genefam,]
  #  row.names(family_subset) <- family_subset$display.name
  disp_name <- paste(family_subset$vectorbase.RU,family_subset$display.name,sep="-")
  family_subset <- subset(family_subset,select=tissue_list)
  column_labels <- c("Ovaries","Palp","Proboscis","Brain","Antenna","Rostrum","Forelegs","Midlegs","Hindlegs","Abdominal tip","Brain","Antenna","Rostrum","Forelegs","Midlegs","Hindlegs","Abdominal tip")
  heatmap.2(log10(as.matrix(family_subset)+1),dendrogram="none",Colv=FALSE,sepwidth=c(.5,.5),
            trace="none",labCol=column_labels,srtCol=45,density.info="none",labRow=disp_name,
            key.xlab="Log10(TPM+1)",key.title=NA,
            breaks= seq(0,maxTPM,length.out=256),
            col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255)
            # col = colorRampPalette(rev(brewer.pal(9,"Blues")))(255) 
            # col = rev(viridis(100))
  )
  dev.off()
}

family_list <- levels(gene_annotations$gene.family)
family_list <- family_list[2:length(family_list)]

for (maxTPM in c(1,1.5,2,2.5,3,3.5,4,5)) {
  for (fam in family_list)  {
    fname = paste(paste(paste("plots",fam,sep="/"),maxTPM,sep="."),"pdf",sep=".")
    if(!fam %in% c("Neurotransmitter receptor")) {
      genefamily_heatmap(fam,compiled_means,fname,maxTPM) }
  }
}

ppk_temp <- c("gene11000",
              "gene1183",
              "gene10535",
              "gene13236",
              "gene9054",
              "gene9202",
              "gene6186",
              "gene13798",
              "gene13799",
              "gene15576",
              "gene7184",
              "gene10988",
              "gene10989",
              "gene10990",
              "gene11417",
              "gene11522",
              "gene14546",
              "gene14549",
              "gene14571",
              "gene2343",
              "gene7416",
              "gene7417",
              "gene7426",
              "gene764",
              "gene11803",
              "gene11804",
              "gene11805",
              "gene11525",
              "gene7933",
              "gene13416",
              "gene1378",
              "gene9523",
              "gene3871",
              "gene10987",
              "gene7423",
              "gene7720",
              "gene11802")


