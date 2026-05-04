
from cyvcf2 import VCF, Writer
import random 

input="/work/williarj/williarj/2627_HJH_Thesis/data/Ebrahimi_3_3_2026_subsets/3_subsampled_top10_loci10.vcf"
output="/work/williarj/williarj/2627_HJH_Thesis/scripts/data_preparation/test.vcf"

# Randomly select between the two haplotypes at an allele
# Input: gt = [0, 1, False] where 0/1 and phasing=False
# Returns: first haplotype (0) or the second (1) with 50/50
def select_random_haplo(gt):
    if random.random() < 0.5:
        hap=gt[0]
    else:
        hap=gt[1]
    return hap


# v - Varient object; column in vcf
# v.genotypes =
#  [
    # loci: [0,0,False], [0,1,False], ... (one for each individuals)
    # loci ...
# ]
def breed_ind_at_indexes(vcf, index_parent_1, index_parent_2):
    w = Writer(output, vcf)
    
    vcf_samples = vcf.samples
    ind_name = f"F1_{index_parent_1}_{index_parent_2}"
    vcf_samples.append(ind_name)
    w.set_samples(vcf_samples)
    
    for v in vcf:
        gts=v.genotypes
        gt_1=gts[index_parent_1]
        gt_2=gts[index_parent_2]
        
        # Randomly select a haplotype
        hap_1 = select_random_haplo(gt_1)
        hap_2 = select_random_haplo(gt_2)
        
        new_gt = [hap_1,hap_2,False]
        
        # Add to the genotypes for that variant 
        gts.append(new_gt)
        v.genotypes = gts
        print(v)

        w.write_record(v)
    w.close()

# For every varient (record) we want to select a random allele from each loci to create a new

vcf = VCF(input)

# For inds 0 and 1, randomly select one haplotype from each parent at each varient and add to genotypes
breed_ind_at_indexes(vcf, 0, 1)

    
    

