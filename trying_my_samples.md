# Here I am trying to use obitools in 10 samples:
    cd ~/thesis_project/exploring_obitools
    conda activate obi

    ls my_data/raw_reads

# Checking if there is unique tags in the reads or not:

    grep -i -E 'AAGAGGCA.*AAGGAGTA' my_data/raw_reads/135_62_S62_R1_001.fastq
    # Here I see, the tags are coming from this sample, as they are present in the header

# Checking if my reads contains markers or not:

## First with cytb samples:
    
    grep '^@' my_data/raw_reads/15_11_S11_R1_001.fastq | wc -l # 6371 sequences are present here !!

    grep -i -E 'CCATCCAACATCTCAGCATGATGAAA' my_data/raw_reads/15_11_S11_R1_001.fastq | wc -l # Forward primer is present in 246 reads here
    
    ## Here I am confused because only 246 reads have primer out of 6k total reads for this sample.

    
    grep '^@' my_data/raw_reads/169_30_S30_R1_001.fastq | wc -l # 7118 sequences are present here !!
    
    grep -i -E 'CCATCCAACATCTCAGCATGATGAAA' my_data/raw_reads/169_30_S30_R1_001.fastq | wc -l # Forward primer is present in 1280 reads here


## Now with 12S samples:

    grep '^@' my_data/raw_reads/135_62_S62_R1_001.fastq | wc -l # 35344 sequences are present here !!    

    grep -i -E 'ACTGGGATTAGATACCCC' my_data/raw_reads/135_62_S62_R1_001.fastq | wc -l # Forward primer is present in 34495 reads here


# Actual work starts here:

### Step 1: Adding forward tag at the beginning of all sequences from respective sample:

    In a for loop that runs line by line:
        I need to read the first column in file my_data/tags_list.txt (cat my_data/tags_list.txt)
        open the file with file name starting with the value in the first column
        grep for the tags in second+third column
        in the line just below the match: add tags in the second column at beginning and the tags in rhe third column at the last of the sequences
        save and exit !!

    
#### creating a bash script for this:

    # please check the folder 'scripts' for the file:

    chmod +x ../scripts/grep_sequences.sh
    ../scripts/grep_sequences.sh
    ls 'raw_reads/180_80_*.fastq'

#### Checking the results:

    grep -i 'AAGAGGCA+AAGGAGTA' my_data/temp/135_62_S62_R1_001.fastq | wc -l # 33314 is the count
    grep -i -E 'AAGAGGCA.*AAGGAGTA' my_data/temp/135_62_S62_R1_001.fastq | wc -l # 66631 is the count

    # Unique tags are attached !!



### Creating a txt file with the list of sample_ids, tags and primers:

    # I have created that file and saved as: my_data/tags_list.txt
    cat my_data/tags_list.txt
    
    ls my_data/raw_reads
    grep -i -E 'GCTCATGA+CGTCTAAT' my_data/raw_reads/135_62_*.fastq
    head -n 1 raw_reads/180_80_S80_R1_001.fastq

### Concatenating all forward (and reverse) reads together (multiplexing):

    cd my_data && mkdir multiplexed_files

    cat temp/*_R1_001.fastq >> multiplexed_files/forward_reads.fastq

    cat temp/*_R2_001.fastq >> multiplexed_files/reverse_reads.fastq

    cd multiplexed_files && ls
    cat forward_reads.fastq | wc -l
    cat reverse_reads.fastq | wc -l

### Merging pair end reads:

    mkdir ../intermediate_results
    illuminapairedend --score-min=30 -r reverse_reads.fastq forward_reads.fastq > ../intermediate_results/merged.fastq

# Chekng the merged files:

    head -n 8 reverse_reads.fastq

    grep -E '^@' reverse_reads.fastq | wc -l
    # gives: 182959

    grep -E '^+' reverse_reads.fastq | wc -l
    # gives 716116

    cat reverse_reads.fastq | wc -l
    # also gives 716116