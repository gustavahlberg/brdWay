#Count Mendelian violations for each family in a callset with multiple families (and provided pedigree)
# Java -jar GenomeAnalysisTK.jar \
#   -T VariantEval \
#   -R reference.fasta \
#   -o output.MVs.byFamily.table \
#   --eval multiFamilyCallset.vcf \
#   -noEV -noST \
#   -ST Family \
#   -EV MendelianViolationEvaluator
