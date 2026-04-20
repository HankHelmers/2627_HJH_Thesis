#
# DOES NOT WORK
#


#!/bin/bash

VCF=$1
OUT=$2

# # Step 0: filter polymorphic loci
# bcftools view -i 'AC>0 && AC<AN' $VCF -Oz -o filtered.vcf.gz
# bcftools index filtered.vcf.gz

# Step 1: sample names
bcftools query -l $VCF > interm_samples.txt

# Step 2: extract genotypes
bcftools query -f '[%GT\t]\n' $VCF > interm_matrix.txt

# Step 3: transpose
#   Need to make the individuals from columns to rows for newhybrids
awk '
{
  for (i=1; i<=NF; i++) a[NR,i]=$i
}
NF>p {p=NF}
END {
  for (i=1; i<=p; i++) {
    for (j=1; j<=NR; j++) printf "%s ", a[j,i]
    printf "\n"
  }
}
' interm_matrix.txt > interm_samples_by_loci.txt

# Step 4: split into two rows
#   Split the alleles from 0/0 form to 0, 1, 2 form 
awk '
{
  line1=""
  line2=""
  
  for(i=1; i<=NF; i++) {
    if($i=="./.") {
      a1=0; a2=0
    } else {
      split($i,a,"/")
      a1=a[1]+1
      a2=a[2]+1
    }
    
    line1 = line1 a1 " "
    line2 = line2 a2 " "
  }
  
  print line1
  print line2
}
' interm_samples_by_loci.txt > interm_geno_2rows.txt

# Step 5: duplicate IDs
#   Currently one individuals per line like IND1: (all info)
#   But it needs to be like IND1: (first allele)
#                           IND1: (second allele)
awk '{print; print}' interm_samples.txt > interm_samples_2rows.txt

# Step 6: combine
paste interm_samples_2rows.txt interm_geno_2rows.txt > $OUT

# Remove all intermediate files (inter*)
rm interm*