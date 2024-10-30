
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
setwd("//Users/roxannelariviere/Desktop/Dark genome/Results/GWAS/OPERA IF/Batch4/2024-03-06_GWAS_6w_TH-Syn-Map2[21916]/2024-03-06T112028-0500[22773]")

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
         
         "Spots" = "Nuclei.Selected..2..Selected...Number.of.Spots",
         "Spot_intensity" = "Nuclei.Selected..2..Selected...Relative.Spot.Intensity") %>% 
  mutate(Identifier = paste(PlateID, WellName, sep="-")) %>%
  dplyr::select(Identifier, PlateID, WellName, Field, A647, A488, A555, Nuclei_roundness, Nuclei_area, Cell_area, Spots, Spot_intensity)


# Convert the data to tbl format (this is a dataframe format that is optimized for fast calculations in R - speeds up the operation of future steps)
IF_data_total <- as_tibble(IF_data_total) 

# Add labels according to the design of the experiment
#Label Cell Line Genotype
IF_named <- IF_data_total %>%
  mutate(WellName = as.character(WellName),
         Well = substr(WellName, 2, 3),
         Genotype = ifelse(Well == 2, "CTRL2", 
                        ifelse(Well == 3, "CTRL4",
                               ifelse(Well == 4, "CTRLG",
                                      ifelse(Well == 5, "SNCA_KO",
                                             ifelse(Well == 6, "PINK1_KO",
                                                    ifelse(Well == 7, "INPP5F_KO", 
                                                           ifelse(Well == 8, "IGSF9B_KO",
                                                                  ifelse(Well == 9, "SH3GL2_KO",
                                                                         ifelse(Well == 10, "IP6K2_KO",
                                                                                ifelse(Well == 11, "NA", NA))))))))))) 


# Add labels according to the design of the experiment
#Label Cell Line treatment
IF_named <- IF_named %>%
  mutate(WellName = as.character(WellName),
         Well = substr(WellName, 1, 1),
         Treatment = ifelse(Well == "B", "Vehicle", 
                            ifelse(Well == "C", "Vehicle",
                                   ifelse(Well == "D", "Vehicle",
                                          ifelse(Well == "E", "NA",
                                                 ifelse(Well == "F", "NA",
                                                        ifelse(Well == "G", "NA", NA)))))))


# Label IF Staining Condition
IF_named <- IF_named %>%
  mutate(WellName = as.character(WellName),
         Well2 = substr(WellName, 2, 3),
         Stain = ifelse(Well2 == 2, "TH/SynBD/Map2", 
                        ifelse(Well2 == 3, "TH/SynBD/Map2",
                               ifelse(Well2 == 4, "TH/SynBD/Map2",
                                      ifelse(Well2 == 5, "TH/SynBD/Map2",
                                             ifelse(Well2 == 6, "TH/SynBD/Map2",
                                                    ifelse(Well2 == 7, "TH/SynBD/Map2", 
                                                           ifelse(Well2 == 8, "TH/SynBD/Map2",
                                                                  ifelse(Well2 == 9, "TH/SynBD/Map2",
                                                                         ifelse(Well2 == 10, "TH/SynBD/Map2",
                                                                                ifelse(Well2 == 11, "NA", NA))))))))))) 



IF_named <- IF_named %>%
  mutate(Timepoint = "6w")


## Write processed file to csv

write.csv(IF_named, "//Users/roxannelariviere/Desktop/Dark genome/Results/GWAS/OPERA IF/Batch4/2024-03-06_GWAS_6w_TH-Syn-Map2[21916]/2024-03-06T112028-0500[22773].csv")

