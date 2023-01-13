### Paths to necessary files for USEQ Analysis

# Path to base directory where you want your USEQ files to be created. Don't forget to add a "/" at the end as we want the files to be created inside this directory.
base_dir="/Users/chadpollard/Desktop/Air_Quality_Study/"

# Path to Control Beta values (Make sure it is a .csv file CG's are in the rows and sample names are in the columns)
control_betas="/Users/chadpollard/Desktop/Air_Quality_Study/S_P_beta_values.csv"

# Path to Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and sample names are in the columns)
treatment_betas="/Users/chadpollard/Desktop/Air_Quality_Study/R_P_beta_values.csv"

# Path to Annotation File (Make sure it is a .csv file and that CG's are in the rows and that CHR and START are in the columns)
illumina_annotation="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/Annotation_Files/EPIC_array_annotation.csv"

# Path to Python_script.py script (This file can be downloaded from this github link: )
python_script_path="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/Python_script.py"

# Path to Sgr2Bar program
Sgr2Bar="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/Sgr2Bar"

# Path to MethylationArrayScanner program
MethylationArrayScanner="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/MethylationArrayScanner"

# Path to EnrichedRegionMaker program
EnrichedRegionMaker="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/EnrichedRegionMaker"

# Path to Control group names (Must be comma delimited with no spaces)
Control_Samples=203010900034_R02C01,203010900034_R08C01,203011620056_R01C01,203011620056_R02C01,203011620056_R03C01,203013220102_R06C01,203013220106_R04C01,203017150072_R07C01,203020780073_R01C01,203020780073_R02C01,203020780073_R03C01,203020780073_R04C01,203020780073_R05C01,203021070138_R01C01,203021070138_R02C01,203021070138_R03C01,203021070138_R04C01,203021070138_R08C01,203026840036_R08C01,203026840080_R06C01

# Path to Testing group names (Must be comma delimited with no spaces)
Treatment_Samples=203010900034_R04C01,203010900034_R05C01,203010900034_R06C01,203010900034_R07C01,203011620056_R04C01,203011620056_R07C01,203011620056_R08C01,203013220102_R03C01,203013220102_R04C01,203013220102_R07C01,203013220102_R08C01,203017150072_R02C01,203017150072_R04C01,203017150072_R08C01,203020780073_R06C01,203021070138_R06C01,203026840036_R06C01,203026840044_R02C01,203026840080_R07C01



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
for d in ./*/ ; do (java -jar $Sgr2Bar -f $USEQ_Prep${d} -v H_Sapiens_Feb_2009); done

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
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Forward/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,10


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
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Reverse/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,10
echo "Finished!"