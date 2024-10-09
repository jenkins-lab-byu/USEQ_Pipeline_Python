### Paths to necessary files for USEQ Analysis

# Path to base directory where you want your USEQ files to be created. Don't forget to add a "/" at the end as we want the files to be created inside this directory.
base_dir="/Volumes/Research_Data/Research_Datasets/USEQ_Analyses/Neuro_Panel/IPSC_Spinal_vs_Blood_Plasma/"

# Path to Control Beta values (Make sure it is a .csv file CG's are in the rows and sample names are in the columns)
control_betas="/Volumes/Research_Data/Research_Datasets/USEQ_Analyses/Neuro_Panel/IPSC_Spinal_vs_Blood_Plasma/spinal_beta_values.csv"

# Path to Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and sample names are in the columns)
treatment_betas="/Volumes/Research_Data/Research_Datasets/USEQ_Analyses/Neuro_Panel/Cortical_Neurons_vs_Blood_Plasma/Blood_Plasma_betas.csv"

# Path to Annotation File (Make sure it is a .csv file and that CG's are in the rows and that CHR and START are in the columns)
illumina_annotation="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USEQ_Pipeline_Python_EPICv2/Annotation_Files/EPICv2_USEQanno.csv"

# Path to Python_script.py script (This file can be downloaded from this github link: )
python_script_path="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USEQ_Pipeline_Python_EPICv2/Python_script_epicv2.py"

# Path to Sgr2Bar program
Sgr2Bar="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/Sgr2Bar"

# Path to MethylationArrayScanner program
MethylationArrayScanner="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/MethylationArrayScanner"

# Path to EnrichedRegionMaker program
EnrichedRegionMaker="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/EnrichedRegionMaker"

# Path to Control group names (Must be comma delimited with no spaces)
Control_Samples=207215820064_R05C01,207215820064_R06C01

# Path to Testing group names (Must be comma delimited with no spaces)
Treatment_Samples=207215820005_R01C01,207215820005_R02C01,207215820005_R03C01,207215820005_R04C01


###########
## Creating USEQ Directories ##
###########
echo ""
echo "**** Creating USEQ Directories ****"
echo ""

# Change to USEQ_prep directory
cd $base_dir
mkdir USEQ_Prep
mkdir USEQ_Results_Forward
mkdir USEQ_Results_Reverse
USEQ_Prep="${base_dir}/USEQ_Prep/"
cd $USEQ_Prep

###########
## Creating SGR Files ##
###########
echo ""
echo "**** Running Python-Script and Creating SGR Files ****"
echo ""

# Rscript $sgr_script --base_dir $base_dir --control_betas $control_betas --treatment_betas $treatment_betas --illumina_annotation $illumina_annotation --USEQ_Prep $USEQ_Prep
# python $python_script_path --sam ${i}.sam --targets $targets_file_path
python $python_script_path --base_dir $base_dir --control_betas $control_betas --treatment_betas $treatment_betas --illumina_annotation $illumina_annotation --USEQ_Prep $USEQ_Prep

###########
## Converting SGR Files to Bar Files ##
###########
echo ""
echo "**** Converting SGR Files to Bar Files ****"
echo ""

# Convert .sgr files to .bar files
# This is designed for genome build hg38
for d in ./*/ ; do (java -jar $Sgr2Bar -f $USEQ_Prep${d} -v H_Sapiens_Dec_2013); done

###########
## Removing SGR files ##
###########
echo ""
echo "**** Removing SGR files ****"
echo ""

# Remove .sgr files
for d in ./*/ ; do (cd "$d" && rm *.sgr); done


###########
## Removing Leftover Subdirectories ##
###########
echo ""
echo "**** Removing Leftover Subdirectories ****"
echo ""

# Move any file in the sub directory and place it into the working directory
for d in ./*/ ; do (cd "$d" && find . -mindepth 2 -type f -print -exec mv {} . \;); done

# Remove subdirectories
for d in ./*/ ; do (cd "$d" && rm -R -- */); done


###########
## Running Sliding Window Analysis Forward ##
###########
echo ""
echo "**** Running Sliding Window Analysis Forward ****"
echo ""

#Sliding Window Analysis
java -jar $MethylationArrayScanner -s ../USEQ_Results_Forward -d $USEQ_Prep -c $Control_Samples -t $Treatment_Samples -n

###########
## Creating Output Using Enriched Region Maker App ##
###########
echo ""
echo "**** Creating Forward Output Using Enriched Region Maker App ****"
echo ""

#Creating output using enriched region maker app
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Forward/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,13


###########
## Running Sliding Window Analysis Reverse ##
###########
echo ""
echo "**** Running Sliding Window Analysis Reverse ****"
echo ""

java -jar $MethylationArrayScanner -s ../USEQ_Results_Reverse -d $USEQ_Prep -t $Control_Samples -c $Treatment_Samples -n


###########
## Creating Output Using Enriched Region Maker App ##
###########
echo ""
echo "**** Creating Reverse Output Using Enriched Region Maker App ****"
echo ""

#Creating output using enriched region maker app
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Reverse/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,13
echo "Finished!"