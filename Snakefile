# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: "config.yaml"

CONDAENV='envs'
BINNING_BAM: config['BINNING_BAM']
BINNING_CONTIGS: config["BINNING_CONTIGS"]
BB_COVERAGE_FILE : config["BB_COVERAGE_FILE"]


if config.hasattr('samples'):
    SAMPLES = config['samples']
else:
    SAMPLES, = glob_wildcards(BINNING_CONTIGS)


rule all:
    input:
        expand("{{sample}}/binning/{binner}/cluster_attribution.tsv",
                binner= config['binner'],samples=SAMPLES)

        # The first rule should define the default target files
        # Subsequent target rules can be specified below. They should start with all_*.


include: "rules/binner.snakefile"
