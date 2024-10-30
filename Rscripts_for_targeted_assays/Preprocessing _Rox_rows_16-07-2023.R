
# Load required packages
library(tidyverse)
library(here)
library(dplyr)
library(RColorBrewer)
library(gridExtra)
library(ggpubr)
library(rstatix)
library(knitr)

##Set working directory contauining the data of interest (shouls be a set of text files, one for each well analyzed)
setwd("/Users/roxannelariviere/Desktop/Dark genome/Results/GWAS/OPERA IF/Batch2/Batch2_04-08-2023_GWAS_6w_POL_PFF_pSyn-303_Map2-2[9853]/4-08-2023_GWAS_6w_POL_PFF_pSyn-303-Map2[20453]/2023-08-04T112514-0400[21256]")

# The following several steps list and open the desired files
# List text files using pattern * in name
files <- list.files(pattern = "*].txt", full.names = T, recursive = T)

# Extract files wiith "population" in the naming scheme --> this is a filter to exclude any other text files that might be present in the samne folder
IF_files <- files[grep("Population", files)]

# Use "Lapply" to open all files in the list using the "read.delim" function
# Output is a list of dataframes corresponding to each well in the dataset 
IF_list <- lapply(IF_files, function(x) {
        tmp <- try(read.delim(x))
        if (!inherits(tmp, 'try-error')) tmp
})

# Subset to remove null values (undefined values) if present, and creates new list of dataframes
IF_data <- IF_list[!sapply(IF_list, is.null)]

#Merge individual dataframes into one large datset containing all the wells of the experiment
# select and rename the variables we want to carry forward in the analysis
IF_data_total <- bind_rows(IF_data) %>%  
        rename("Nuclei_roundness" = "Nuclei.Selected..2..Selected...Nucleus.Roundness..2.", 
               "Nuclei_area" = "Nuclei.Selected..2..Selected...Nucleus.Area..µm....2.",
               "Cell_area" = "Nuclei.Selected..2..Selected...Cell.Area..µm..",
               "A647" = "Nuclei.Selected..2..Selected...A647.Mean",
               "A555" = "Nuclei.Selected..2..Selected...A555.Mean",
               "A488" = "Nuclei.Selected..2..Selected...A488.Mean",
               "Spot_area" = "Nuclei.Selected..2..Selected...Total.Spot.Area",
               "Spot_count" = "Nuclei.Selected..2..Selected...Number.of.Spots",
               "Spot_intensity" = "Nuclei.Selected..2..Selected...Relative.Spot.Intensity") %>% 
        mutate(Identifier = paste(PlateID, WellName, sep="-")) %>%
        dplyr::select(Identifier, PlateID, WellName, Field, A647, A488, A555, Nuclei_roundness, Nuclei_area, Cell_area, Spot_area, Spot_count, Spot_intensity)

# Convert the data to tbl format (this is a dataframe format that is optimized for fast calculations in R - speeds up the operation of future steps)
IF_data_total <- as_tibble(IF_data_total) 

# Add labels according to the design of the experiment
#Label Cell Line Genotype
IF_named <- IF_data_total %>%
        mutate(WellName = as.character(WellName),
               Well = substr(WellName, 1, 1),
               Genotype = ifelse(Well == "B", "Control", 
                                     ifelse(Well == "C", "SNCA-KO",
                                            ifelse(Well == "D", "INPP5F-KO",
                                                   ifelse(Well == "E", "ISGF9B-KO",
                                                          ifelse(Well == "F", "SH3GL2-KO",
                                                                 ifelse(Well == "G", "IP6K2-KO", NA)))))))

# Label Staining Condition
IF_named <- IF_named %>%
        mutate(WellName = as.character(WellName),
               Well2 = substr(WellName, 2, 3),
               Treatment = ifelse(Well2 == 2, "PFF", 
                              ifelse(Well2 == 3, "PFF",
                                     ifelse(Well2 == 4, "PFF",
                                            ifelse(Well2 == 5, "PFF",
                                                   ifelse(Well2 == 6, "PFF",
                                                          ifelse(Well2 == 7, "Vehicle", 
                                                                 ifelse(Well2 == 8, "Vehicle",
                                                                        ifelse(Well2 == 9, "Vehicle",
                                                                               ifelse(Well2 == 10, "Vehicle",
                                                                                      ifelse(Well2 == 11, "Vehicle", NA))))))))))) 




# Label Staining Condition
IF_named <- IF_named %>%
        mutate(WellName = as.character(WellName),
               Well2 = substr(WellName, 2, 3),
               Stain = ifelse(Well2 == 2, "NA", 
                                  ifelse(Well2 == 3, "pSyn/303/Map2",
                                         ifelse(Well2 == 4, "pSyn/303/Map2",
                                                ifelse(Well2 == 5, "pSyn/303/Map2",
                                                       ifelse(Well2 == 6, "pSyn/303/Map2",
                                                              ifelse(Well2 == 7, "pSyn/303/Map2", 
                                                                     ifelse(Well2 == 8, "pSyn/303/Map2",
                                                                            ifelse(Well2 == 9, "pSyn/303/Map2",
                                                                                   ifelse(Well2 == 10, "pSyn/303/Map2",
                                                                                          ifelse(Well2 == 11, "pSyn/303/Map2", NA))))))))))) 







## Write processed file to csv

write.csv(IF_named, "/Users/roxannelariviere/Desktop/Dark genome/Results/GWAS/OPERA IF/Batch2/Batch2_04-08-2023_GWAS_6w_POL_PFF_pSyn-303_Map2-2[9853]/4-08-2023_GWAS_6w_POL_PFF_pSyn-303-Map2[20453]/2023-08-04T112514-0400[21256].csv")

