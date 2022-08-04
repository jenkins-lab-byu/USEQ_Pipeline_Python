print("Loading Packages...")
import pandas as pd
# import numpy as np 
import argparse
# import seaborn as sns
# import matplotlib.pyplot as plt
# from sklearn.preprocessing import StandardScaler
# import pyreadr
import os


##  Reading in sample_sheet
# sample_sheet = pd.read_csv("/Volumes/Research_Data/Research_Datasets/Brain_Tissue/Alzheimers_OC_FC_TC_450K/sample_sheet.csv",header = 0, index_col=0)
# sample_sheet.iloc[:]


# #  If you need to subset for a specific control sample type you can
# control_subset = []
# for i in sample_sheet.index:
#     if sample_sheet.loc[i,"Cell_Type"] == "bulk_CTRL_Frontal Cortex" or sample_sheet.loc[i,"Cell_Type"] == "bulk_CTRL_Temporal Cortex":
#         control_subset.append(i)
# print(len(control_subset))
# beta_values = pd.read_csv("/Volumes/Research_Data/Research_Datasets/Brain_Tissue/Alzheimers_OC_FC_TC_450K/Occipital_Frontal_Temporal_450K_beta_values.csv",header = 0,index_col = 0)
# control = beta_values.loc[:,control_subset]
# control.to_csv("/Volumes/Research_Data/USEQ_Analyses/Bulk_vs_Bulk_AD/bulk_control_betas.csv")
# control.iloc[:]


# #  If you need to subset for a specific treatment sample type you can
# treatment_subset = []
# for i in sample_sheet.index:
#     if sample_sheet.loc[i,"Cell_Type"] == "bulk_AD_Frontal Cortex" or sample_sheet.loc[i,"Cell_Type"] == "bulk_AD_Temporal Cortex":
#         treatment_subset.append(i)
# print(len(treatment_subset))
# # beta_values = pd.read_csv("/Volumes/Research_Data/Research_Datasets/Blood_Plasma/Prostate_Study_450K/Prostate_Study_450K_beta_values.csv",header = 0,index_col = 0)
# treatment = beta_values.loc[:,treatment_subset]
# treatment.to_csv("/Volumes/Research_Data/USEQ_Analyses/Bulk_vs_Bulk_AD/bulk_ad_betas.csv")
# treatment.iloc[:]


# ann_EPIC = pd.read_csv("/Volumes/Research_Data/My_Github/USEQ-Pipeline/Annotation_Files/450k_annotation.csv",header = 0,index_col = 0,dtype=str)
# ann_EPIC.iloc[:]
# mydf = pd.merge(ann_EPIC,control,left_index=True,right_index=True)
# mydf = pd.merge(mydf,treatment,left_index=True,right_index=True)
# mydf.iloc[:]


###############
## ARGUMENTS ##
###############
##  Add Arguments from command line
parser=argparse.ArgumentParser(description='Creating .sgr files for USEQ analysis')
parser.add_argument('--base_dir', help='Path to base directory',type=str, required=True)
parser.add_argument('--control_betas', help='Path to control beta values',type=str, required=True)
parser.add_argument('--treatment_betas', help='Path to treatment beta values',type=str, required=True)
parser.add_argument('--illumina_annotation', help='Path to illumina annotation file',type=str, required=True)
parser.add_argument('--USEQ_Prep', help='Path to USEQ Prep Folder',type=str, required=True)

## get arguments
args = parser.parse_args()
base_dir=args.base_dir
control_betas=args.control_betas
treatment_betas=args.treatment_betas
illumina_annotation=args.illumina_annotation
USEQ_Prep=args.USEQ_Prep

# Set directory where you want the USEQ_Prep directory and files to be put
path_to_my_dir = base_dir
os.chdir(path_to_my_dir)
print("Home Directory has been set to", path_to_my_dir)
path_to_USEQ_Prep = USEQ_Prep

# Read Control Betas, Treatment Betas, and the desired annotation file (This one is EPIC)
print("Reading in Control Beta Values")
control = pd.read_csv(control_betas,header = 0,index_col = 0)
print("Reading in Treatment Beta Values")
treatment = pd.read_csv(treatment_betas,header = 0,index_col = 0)
print("Reading in Annotation File")
ann_EPIC = pd.read_csv(illumina_annotation,header = 0,index_col = 0)

# Merge Each File
print("Merging Annotation File")
print("Merging Control Betas File")
mydf = pd.merge(ann_EPIC,control,left_index=True,right_index=True)
print("Merging Treatment Betas File")
mydf = pd.merge(mydf,treatment,left_index=True,right_index=True)
mydf.iloc[:5,:]

# Create .sgr files
chrom = ["chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY"]
count = 2
# os.mkdir("/Volumes/Research_Data/USEQ_Analyses/Bulk_vs_Bulk_AD/USEQ_Prep")
for sample in mydf.columns:
    if sample == "CHR" or sample == "START":
        continue
    else:
        os.mkdir(path_to_USEQ_Prep + sample)
        sample_subset = mydf.iloc[:, [0,1,count]]
        sample_subset = sample_subset.astype({'START':'int'})
        count += 1
        for i in chrom:
            c = sample_subset.loc[sample_subset["CHR"] == i,["CHR","START",sample]]
            c.to_csv(path_to_USEQ_Prep + sample + "/" + i + ".sgr", sep = "\t",header=False,index=False)
        print("Finished creating .sgr chromosome files for sample",count-2,"of",len(mydf.columns)-2)