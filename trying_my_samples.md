# Here I am trying to use obitools in 10 samples:
    ls my_data/raw_reads

# Checking if there is unique tags in the reads or not:

    grep -i -E 'AAGAGGCA.*AAGGAGTA' my_data/raw_reads/135_62_S62_R1_001.fastq
    # Here I see, the tags are coming from this sample, as they are present in the header

# Checking if my reads contains markers or not:
    # Here I am confused because both Forward and Reverse marker sequence are present in huge number in w


# Actual work starts here:
### Step 1: Adding forward tag at the beginning of all sequences from respective sample:
    In a for loop that runs line by line:
        I need to read the first column in file my_data/tags_list.txt (cat my_data/tags_list.txt)
        open the file with file name starting with the value in the first column
        grep for the tags in second+third column
        in the line just below the match: add tags in the second column at beginning and the tags in rhe third column at the last of the sequences
        save and exit !!

    
### creating a bash script for this:

chmod +x ../scripts/grep_sequences.sh
../scripts/grep_sequences.sh
ls 'raw_reads/180_80_*.fastq'

### Step 3: 
ls my_data/raw_reads
grep 'GCTCATGA+CGTCTAAT' raw_reads/180_80_*.fastq
head -n 1 raw_reads/180_80_S80_R1_001.fastq