# INPUTS
PCA_name=pca_unpruned
VCF=minivcf.vcf.gz

# ----------------------------------------------------------------------
EXPER_PWD=$PWD # Save experiment directory

# Go to folder with data
cd ../../data/Ebrahimi_3_3_2026_download

# prune and create pca
plink --vcf $VCF --double-id --allow-extra-chr --set-missing-var-ids @:# \
--make-bed --pca --out $EXPER_PWD/$PCA_name

# Move output files to new folder 
cd $EXPER_PWD
mkdir -p $PCA_name # Make folder for PCA results
mv $PCA_name* $PCA_name
