# Save experiment directory
EXPER_PWD=$PWD

cd ../../data/Ebrahimi_3_3_2026_download

VCF=minivcf.vcf.gz

plink --vcf $VCF --double-id --allow-extra-chr \
--missing --out $EXPER_PWD/missing_report