# Exploring OBITools

This project involves using OBITools to analyze DNA sequencing data, specifically to explore the diet of wolves from fecal samples. This README provides step-by-step instructions to set up the environment, install necessary tools, and process the sample data.

## Prerequisites
Ensure you have the following software installed:
- `wget`
- `bash`
- An internet connection for downloading required files.

## Project Setup

### Create Project Directory
- Create a project directory and navigate to it.

### Installing Conda
1. Create a tools directory and navigate into it.
2. Download and install the latest version of Anaconda for Linux.
3. Run the installer and follow the prompts.
4. Add Anaconda to your system's PATH by initializing it.
5. Restart the terminal source to apply changes.
6. Verify the installation by checking the Conda version.

### Installing OBITools in a Dedicated Environment
1. Create a Conda environment with Python 2.7 and activate it.
2. Add the necessary channels: `defaults`, `bioconda`, and `conda-forge`.
3. Install OBITools.
4. Verify OBITools installation by running a test command.

## Obtaining Sample Data
1. Go back to the project directory.
2. Create a data directory and download the tutorial dataset.
3. Unzip the dataset and explore the contents.

    **File Descriptions**:
    - `wolf_F.fastq`: Forward fastq reads from 4 fecal samples.
    - `wolf_R.fastq`: Reverse fastq reads from 4 fecal samples.
    - `wolf_diet_ngsfilter.txt`: Primers and tags for each sample.
    - `db_v05_r117.fasta`: Reference database extracted from EMBL using ecoPCR.

## Data Processing Steps

### Merging Paired-end Reads
- Use OBITools to merge paired-end reads. Sequences with an alignment score below 40 will be concatenated instead of aligned.

### Removing Unaligned Sequences
- Filter out unaligned sequences by looking for sequences whose alignment mode is not set to `joined`.

### Viewing the First Sequence
- Use the appropriate OBITools command to inspect the first sequence of the aligned reads.

### Assigning Sequence Records to Samples
- Assign each sequence record to the corresponding sample/marker combination using a filtering tool.

### Dereplicating Duplicate Reads
- Deduplicate the sequences while retaining the sample of origin for each unique sequence.

### Annotating Unique Sequences
- Add annotation fields like `count` and `merged_sample` to each unique sequence's header.

### Denoising the Dataset
- Perform sequence denoising by generating statistics on the sequence counts.
- Filter sequences based on a minimum count threshold and a maximum length threshold, depending on the marker used.

### Cleaning PCR/Sequencing Errors
- Remove PCR and sequencing errors using OBITools with parameters for sample and error threshold.

### Taxonomic Assignment

1. **Building a Reference Database**:
   - Follow the steps to download the EMBL sequences and NCBI taxonomy, format them, and simulate PCR amplification to create a reference database.

2. **Assigning Sequences to Taxa**:
   - Assign each cleaned sequence to a taxon using the reference database.

3. **Removing Unnecessary Attributes**:
   - Clean up the sequence headers by removing unnecessary tags and attributes.

4. **Sorting Sequences by Count**:
   - Sort sequences by their count to prioritize high-occurrence sequences.

## Saving Results
1. Create a results directory to store the final output.
2. Convert the final dataset into a tab-separated format for easy downstream analysis.
3. List the contents of the results directory to verify that the file has been saved.

## Notes
- Ensure you regularly check the sequence headers and attributes during processing to ensure accuracy.
- Further analysis steps, such as generating diversity indices or visualizations, can be performed on the final output dataset.

## References
- [OBITools Documentation](https://pythonhosted.org/OBITools/)
- [Conda Documentation](https://docs.conda.io/projects/conda/en/latest/)
- [*ecoPrimers*](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3241669/)
- [Shehzad et. al, 2012](https://pubmed.ncbi.nlm.nih.gov/22250784/)
