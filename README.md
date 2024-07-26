# PD_assay_panel_analysis
Scripts for analyzing high content microscopy, processed scRNAseq, total RNAseq and proteomics

# Contents

1. High content microscopy analysis
   - Images were first analyzed with Columbus
   - The output results were processed in R (see scripts XXXX.R).
   - The R results were analyzed in prism
2. scRNAseq analysis
   - raw files were processed with scRNAbox (see log files XXXXX). https://neurobioinfo.github.io/scrnabox/site/
   - script for all plots (file.Rmd)
   - scripts for differential gene expression and pathway analysis
3. Total RNAseq
   - Raw FASTQ files to differential gene expression was processed using GenPipes RNAseq https://genpipes.readthedocs.io/en/latest/user_guide/pipelines/gp_rnaseq.html
4. Proteomics were processed by ....
5. Visualization and pathway analysis of processed RNAseq and Proteomics data
   - Heat map comparison to targeted/known PD pathways
   - Differential Gene Expression and pathway analysis
   - Differential Protein Expression and pathway analysis
