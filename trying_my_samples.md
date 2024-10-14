# Here I am trying to use obitools in 10 samples:
    ls my_data/raw_reads

# Checking if there is unique tags in the reads or not:
    grep -i -E 'AAGAGGCA.*AAGGAGTA' my_data/raw_reads/135_62_S62_R1_001.fastq
    # Here I see, the tags are coming from this sample, as they are present in the header

# Checking if my reads contains markers or not:
    # Here I am confused because both Forward and Reverse marker sequence are present in huge number in w


# Actual work starts here:
### Step 1: Adding forward tag at the beginning of all sequences from respective sample:


### Step 2: Adding reverse tag at the end of all sequences from respective sample:


### Step 3: 