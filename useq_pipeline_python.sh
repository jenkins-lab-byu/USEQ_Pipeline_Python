### Paths to necessary files for USEQ Analysis

# Path to base directory where you want your USEQ files to be created. Don't forget to add a "/" at the end as we want the files to be created inside this directory.
base_dir="/Volumes/Research_Data/USEQ_Analyses/Neurons_vs_Whole_Blood/"

# Path to Control Beta values (Make sure it is a .csv file CG's are in the rows and sample names are in the columns)
control_betas="/Volumes/Research_Data/USEQ_Analyses/Neurons_vs_Whole_Blood/neuron_betas_controls_heroin_study.csv"

# Path to Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and sample names are in the columns)
treatment_betas="/Volumes/Research_Data/USEQ_Analyses/Neurons_vs_Whole_Blood/whole_blood_betas_healthy_depression_study.csv"

# Path to Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and that CHR and START are in the columns)
illumina_annotation="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/Annotation_Files/450k_annotation.csv"

# Path to Creating_sgr_files_python.ipynb script (This file can be downloaded from this github link: )
python_script_path="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/Python_script.py"

# Path to Sgr2Bar program
Sgr2Bar="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/Sgr2Bar"

# Path to MethylationArrayScanner program
MethylationArrayScanner="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/MethylationArrayScanner"

# Path to EnrichedRegionMaker program
EnrichedRegionMaker="/Volumes/Research_Data/Jenkins_Lab_Github/USEQ_Pipeline_Python/USeq_9.3.3/Apps/EnrichedRegionMaker"

# Path to Control group names (Must be comma delimited with no spaces)
Control_Samples=GSM2589158_7507875069_R04C01,GSM2589159_7786915003_R02C01,GSM2589160_7786915003_R03C01,GSM2589162_7507875069_R02C02,GSM2589163_7786915003_R04C01,GSM2589164_7507875069_R04C02,GSM2589168_6229068023_R02C01,GSM2589175_7507875069_R03C01,GSM2589181_6229041055_R03C01,GSM2589185_6229041055_R01C02,GSM2589189_6229041055_R05C02,GSM2589191_6190781080_R01C01,GSM2589194_7786915003_R06C02,GSM2589200_7786915111_R03C01,GSM2589204_6190781066_R02C01,GSM2589206_6190781066_R04C01,GSM2589213_6190781066_R05C02,GSM2589218_6229068015_R04C01,GSM2589219_7786915111_R01C02,GSM2589221_6229068015_R01C02,GSM2589223_7786915111_R04C02,GSM2589224_6229068015_R04C02,GSM2589225_7786915111_R05C02,GSM2589227_6190781063_R01C01,GSM2589230_6190781063_R04C01,GSM2589236_6190781063_R04C02,GSM2589237_6190781063_R05C02,GSM2589238_6190781063_R06C02,GSM2589239_6190781062_R01C01

# Path to Testing group names (Must be comma delimited with no spaces)
Treatment_Samples=GSM6057851_8769527096_R03C02,GSM6057852_8769527096_R04C02,GSM6057853_8769527096_R05C02,GSM6057854_8769527096_R06C02,GSM6057855_8942342061_R01C01,GSM6057856_8942342061_R01C02,GSM6057857_8942342061_R02C01,GSM6057858_8942342061_R02C02,GSM6057859_8942342061_R03C01,GSM6057860_8942342061_R03C02,GSM6057861_8942342061_R04C01,GSM6057862_8942342061_R04C02,GSM6057863_8942342061_R05C01,GSM6057864_8942342061_R05C02,GSM6057865_8942342061_R06C01,GSM6057866_8942342061_R06C02,GSM6057867_8963266069_R01C01,GSM6057868_8963266069_R01C02,GSM6057869_8963266069_R02C01,GSM6057870_8963266069_R02C02,GSM6057871_8963266069_R03C01,GSM6057872_8963266069_R03C02,GSM6057873_8963266069_R04C01,GSM6057874_8963266069_R04C02,GSM6057875_8963266069_R05C01,GSM6057876_8963266069_R05C02,GSM6057877_8963266069_R06C01,GSM6057878_8963266069_R06C02,GSM6057879_8963266153_R01C01,GSM6057880_8963266153_R01C02,GSM6057881_8963266153_R02C01,GSM6057882_8963266153_R02C02,GSM6057883_8963266153_R03C01,GSM6057884_8963266153_R03C02,GSM6057885_8963266153_R04C01,GSM6057886_8963266153_R04C02,GSM6057887_8963266153_R05C01,GSM6057888_8963266153_R05C02,GSM6057889_8963266153_R06C01,GSM6057890_8963266153_R06C02



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
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Forward/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,30


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
java -jar $EnrichedRegionMaker -f ../USEQ_Results_Reverse/windowData1000bp0.2MinPse.swi -i 0,1 -s 0.2,30
echo "Finished!"