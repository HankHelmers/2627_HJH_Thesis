import random
import argparse
from cyvcf2 import VCF, Writer

ERROR_RATE = 0.05  # 5% of homozygotes get changed

def random_changes(input, output):
    vcf = VCF(input)
    w = Writer(output, vcf)
    
    for rec in vcf:
        gts = rec.genotypes
        new_gts = []

        for gt in gts:
            a1, a2, phased = gt[0], gt[1], gt[2]

            # only modify homozygous genotypes
            if a1 == a2 and a1 in [0,1] and random.random() < ERROR_RATE:
                # flip to heterozygous
                new_gts.append([0, 1, phased])
            else:
                new_gts.append(gt)

        rec.genotypes = new_gts
        w.write_record(rec)
    
    w.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Get Sample information.')
    parser.add_argument('-i', '--input', required = True) # Input vcf 
    parser.add_argument('-o', '--output', required = True)
    args = parser.parse_args()
    random_changes(args.input, args.output)
