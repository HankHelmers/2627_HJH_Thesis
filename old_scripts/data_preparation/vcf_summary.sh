# Generate summary of VCF information

VCF_FILE=$1

# Number of loci
#   -H : Removes headers
#   wc -l : Counts number of lines 
echo "Number of loci: "
bcftools view -H $VCF_FILE | wc -l 
