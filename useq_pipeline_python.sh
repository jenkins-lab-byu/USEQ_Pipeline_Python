### Paths to necessary files for USEQ Analysis

# Path to base directory where you want your USEQ files to be created. Don't forget to add a "/" at the end as we want the files to be created inside this directory.
base_dir="/Volumes/Research_Data/USEQ_Analyses/Bulk_Temporal_Cortex_vs_Bulk_AD_Temporal_Cortex/"

# Path to Control Beta values (Make sure it is a .csv file CG's are in the rows and sample names are in the columns)
control_betas="/Volumes/Research_Data/USEQ_Analyses/Bulk_Temporal_Cortex_vs_Bulk_AD_Temporal_Cortex/bulk_control_betas.csv"

# Path to Treatment Beta values (Make sure it is a .csv file and that CG's are in the rows and sample names are in the columns)
treatment_betas="/Volumes/Research_Data/USEQ_Analyses/Bulk_Temporal_Cortex_vs_Bulk_AD_Temporal_Cortex/bulk_ad_betas.csv"

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
Control_Samples=GSM2809005_5854945020_R06C01,GSM2809006_5854945020_R01C02,GSM2809007_5854945020_R02C02,GSM2809013_5854945006_R02C01,GSM2809014_5854945006_R03C01,GSM2809015_5854945006_R04C01,GSM2809016_5854945006_R05C01,GSM2809017_5854945006_R06C01,GSM2809018_5854945006_R01C02,GSM2809019_5854945006_R02C02,GSM2809020_5854945006_R03C02,GSM2809021_5854945006_R04C02,GSM2809022_5854945006_R05C02,GSM2809023_5854945006_R06C02,GSM2809025_5900438023_R02C01,GSM2809026_5900438023_R03C01,GSM2809031_5900438023_R02C02,GSM2809032_5900438023_R03C02,GSM2809033_5900438023_R04C02,GSM2809035_5900438023_R06C02,GSM2809036_5900438003_R01C01,GSM2809037_5900438003_R02C01,GSM2809038_5900438003_R03C01,GSM2809055_5854945011_R01C01,GSM2809056_5854945011_R02C01,GSM2809057_5854945011_R03C01

# Path to Testing group names (Must be comma delimited with no spaces)
Treatment_Samples=GSM2809000_5854945020_R01C01,GSM2809001_5854945020_R02C01,GSM2809002_5854945020_R03C01,GSM2809003_5854945020_R04C01,GSM2809004_5854945020_R05C01,GSM2809008_5854945020_R03C02,GSM2809009_5854945020_R04C02,GSM2809010_5854945020_R05C02,GSM2809011_5854945020_R06C02,GSM2809012_5854945006_R01C01,GSM2809024_5900438023_R01C01,GSM2809027_5900438023_R04C01,GSM2809028_5900438023_R05C01,GSM2809029_5900438023_R06C01,GSM2809030_5900438023_R01C02,GSM2809034_5900438023_R05C02,GSM2809039_5900438003_R04C01,GSM2809040_5900438003_R05C01,GSM2809041_5900438003_R06C01,GSM2809042_5900438003_R01C02,GSM2809043_5900438003_R02C02,GSM2809044_5900438003_R03C02,GSM2809045_5900438003_R04C02,GSM2809046_5854945005_R02C01,GSM2809047_5854945005_R03C01,GSM2809048_5854945005_R04C01,GSM2809049_5854945005_R05C01,GSM2809050_5854945005_R06C01,GSM2809051_5854945005_R03C02,GSM2809052_5854945005_R04C02,GSM2809053_5854945005_R05C02,GSM2809054_5854945005_R06C02,GSM2809058_5854945011_R04C01,GSM2809059_5854945011_R05C01,GSM2809060_5854945011_R06C01,GSM2809061_5854945011_R01C02,GSM2809062_5854945011_R03C02,GSM2809063_5854945011_R04C02,GSM2809064_5854945011_R05C02



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