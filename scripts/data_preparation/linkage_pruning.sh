# Save experiment directory
EXPER_PWD=$PWD

cd ../../data/Ebrahimi_3_3_2026_download

VCF=minivcf.vcf.gz

# perform linkage pruning - i.e. identify prune sites
plink --vcf $VCF --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out $EXPER_PWD/linkage