# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.

import os

configfile: os.path.join(os.path.dirname(workflow.snakefile),"config.yaml")


#subworkflow atlas_assemble:
#    snakefile: "/home/kiesers/atlas/atlas/Snakefile"
#    configfile: "../config.yaml"


CONDAENV= os.path.join(os.path.dirname(workflow.snakefile),'envs')
BINNING_BAM= config['BINNING_BAM']
BINNING_CONTIGS=  config["BINNING_CONTIGS"]
BB_COVERAGE_FILE = config["BB_COVERAGE_FILE"]



if 'samples' in config :
    SAMPLES = config['samples']
else:
    SAMPLES, = glob_wildcards(BB_COVERAGE_FILE)

print(SAMPLES)



rule all:
    input:
        expand(BINNING_BAM,sample=SAMPLES),
        expand(BINNING_CONTIGS,sample=SAMPLES),
        expand(BB_COVERAGE_FILE,sample=SAMPLES),
        expand("{sample}/binning/{binner}/cluster_attribution.tsv",
                binner= config['binner'],sample=SAMPLES)

        # The first rule should define the default target files
        # Subsequent target rules can be specified below. They should start with all_*.


include: "rules/binning.snakefile"
