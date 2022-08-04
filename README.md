# Steps to running this USEQ-Pipeline
This is a sliding window pipeline that uses the USEQ tool from the Universtiry of Utah to do a whole genome scan on Illumina Methylation Array data to find differentially methylated regions between two sample groups.

Note: Before running the pipeline you will need to download this repository to your computer and open the 'useq_pipeline.sh' file. Then make the following changes to the file.

## R-packages Required for this pipeline
  1. Minfi
  2. argparse

### 1. Add the pathname to the base directory where you want your USEQ files to be created. Don't forget to add a "/" at the end as we want the files to be created inside this directory.
example:
base_dir="/Volumes/Research_Data/USEQ_Analyses/Completed_Studies/Blood_vs_Neurons/Orbital_Frontal_Cortex_vs_Blood/"

### 2. Add the pathname to the Control Beta values (Make sure it is a .csv file CG's are in the rows and sample names are in the columns)
example:
control_betas="/Volumes/Research_Data/Renew_Diagnostics/Alzheimers_Study/Micro_Array_Data/450k_Data/Neurons/Orbitofrontal_Cortex/control_neuron_betas.csv"

### 3. Add the pathname to the Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and sample names are in the columns)
example:
treatment_betas="/Volumes/Research_Data/Renew_Diagnostics/Alzheimers_Study/Micro_Array_Data/450k_Data/Whole_Blood/peripheral_blood_betas.csv"

### 4. Add the pathname to the Annotation file provided in this repository (Can be either EPIC or 450K depending on which array your data was run on)
example:
illumina_annotation="/Volumes/Research_Data/USEQ_Analyses/Annotation_Files/450k_annotation.csv"

### 5. Path to the 'R_Script.R script' file provided in this repository
example:
sgr_script="/Volumes/Research_Data/USEQ_Analyses/useq_prep_r.R"

### 6. Path to the Sgr2Bar program in the apps folder of the 'USeq_9.3.3' folder provided in this repository
example:
Sgr2Bar="/Volumes/Research_Data/USEQ_Analyses/USeq_9.3.3/Apps/Sgr2Bar"

### 7. Path to the MethylationArrayScanner program in the apps folder of the 'USeq_9.3.3' folder provided in this repository
example:
MethylationArrayScanner="/Volumes/Research_Data/USEQ_Analyses/USeq_9.3.3/Apps/MethylationArrayScanner"

### 8. Path to the EnrichedRegionMaker program in the apps folder of the 'USeq_9.3.3' folder provided in this repository
example:
EnrichedRegionMaker="/Volumes/Research_Data/USEQ_Analyses/USeq_9.3.3/Apps/EnrichedRegionMaker"

### 9. List of Control sample names (Must be comma delimited with no spaces. Must match the column names in the control beta values files from step 2)
example:
Control_Samples=GSM2589158_7507875069_R04C01,GSM2589159_7786915003_R02C01,GSM2589160_7786915003_R03C01,GSM2589162_7507875069_R02C02,GSM2589163_7786915003_R04C01,GSM2589164_7507875069_R04C02,GSM2589168_6229068023_R02C01

### 10. List of Treatment sample names (Must be comma delimited with no spaces. Must match the column names in the control beta values files from step 3)
example:
Testing_Samples=GSM4749846_3999431158_R01C02,GSM4749847_3999431144_R06C01,GSM4749848_3999442091_R05C01,GSM4749849_3999423019_R03C02,GSM4749850_3999431144_R04C02,GSM4749851_3999431158_R03C01,GSM4749852_3999423013_R03C01,GSM4749853_3999423013_R06C02

### 11. Save these changes you made and close the file


Once theses 11 changes have been made you can run the pipeline inside terminal using the 'bash' command followed by the pathname to the 'useq_pipeline.sh' file.
example: bash /Users/chadpollard/Documents/My_Github/USEQ-Pipeline/useq_pipeline.sh

Good luck!
