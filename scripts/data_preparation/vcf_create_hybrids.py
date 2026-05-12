
import pysam
import random 

input="/work/williarj/williarj/2627_HJH_Thesis/data/Ebrahimi_3_3_2026_subsets/3_subsampled_top10_loci10.vcf"
output="/work/williarj/williarj/2627_HJH_Thesis/scripts/data_preparation/test.vcf"

# Randomly select between the two haplotypes at an allele
# Input: gt = [0, 1, False] where 0/1 and phasing=False
# Returns: first haplotype (0) or the second (1) with 50/50
def select_random_haplo(gt):
    # gt is a tuple like (0,1) or (None,None)
    if gt[0] is None or gt[1] is None:
        return None
    
    return gt[0] if random.random() < 0.5 else gt[1]

def make_f1_genotype(gt_1, gt_2):
    if None in gt_1 or None in gt_2:
        return (None, None)
    
    hap_1 = select_random_haplo(gt_1)
    hap_2 = select_random_haplo(gt_2)
    
    return (hap_1, hap_2)

# Access samples: list(header.samples)
def breed_ind_at_indexes(index_parent_1, index_parent_2):
    # For every varient (record) we want to select a random allele from each loci to create a new
    vcf_in = pysam.VariantFile(input)
    
    # Create copy of the vcf header to edit
    header = vcf_in.header.copy()
    
    # Create new sample name (for F1 offspring)
    new_sample = f"F1_{index_parent_1}_{index_parent_2}"
    header.add_sample(new_sample)
    
    print(header.get_samples())
    
    # Create a out vcf with 'header' information
    vcf_out = pysam.VariantFile(output, 'w', header=header)
        
    # Select the parents using input indexes
    samples = list(vcf_in.header.samples)
    parent_1 = samples[index_parent_1]
    parent_2 = samples[index_parent_2]
    
    # For every record in parents, select random from parent
    for record in vcf_in:
        new_record = record.copy()
        
        gt_1 = record.samples[parent_1]["GT"]
        gt_2 = record.samples[parent_2]["GT"]
        print(gt_1)
        
        new_gt = make_f1_genotype(gt_1, gt_2)
        
        # Assign new genotype to that individual 
        new_record.samples[new_sample]["GT"] = new_gt
        
        vcf_out.write(new_record)
        
    vcf_in.close()
    vcf_out.close()

# For inds 0 and 1, randomly select one haplotype from each parent at each varient and add to genotypes
breed_ind_at_indexes(0, 1)

    
    

