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
    
    grep -i -E 'TCTCAGCATGATGAAA' my_data/raw_reads/15_11_S11_R1_001.fastq  # Forward primer is present in 246 reads here

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

# The error looks like:

                File "/home/mp067823/anaconda3/envs/obi/bin/illuminapairedend", line 257, in <module>
                for ali in ba:
            File "/home/mp067823/anaconda3/envs/obi/bin/illuminapairedend", line 162, in alignmentIterator
                ali = buildAlignment(d,r)
            File "/home/mp067823/anaconda3/envs/obi/bin/illuminapairedend", line 145, in buildAlignment
                la.seqB=reverse 
            File "src/obitools/align/_qsassemble.pyx", line 87, in obitools.align._qsassemble.QSolexaReverseAssemble.seqB.__set__
            File "src/obitools/align/_dynamic.pyx", line 88, in obitools.align._dynamic.allocateSequence
            File "src/obitools/_obitools.pyx", line 259, in obitools._obitools.BioSequence.__str__
            File "src/obitools/_obitools.pyx", line 696, in obitools._obitools.DNAComplementSequence.getStr
            File "src/obitools/_obitools.pyx", line 699, in genexpr
            File "src/obitools/_obitools.pyx", line 705, in obitools._obitools.DNAComplementSequence.getSymbolAt
            KeyError: '+'

# Cheking the merged files:


    head -n 8 reverse_reads.fastq

    grep -E '^@' reverse_reads.fastq | wc -l
    # gives: 182959

    grep -E '^+' reverse_reads.fastq | wc -l
    # gives 716116

    cat reverse_reads.fastq | wc -l
    # also gives 716116

# ############
head -n 4 ../../data/wolf_tutorial/wolf_F.fastq
head -n 4 forward_reads.fastq
head -n 4 reverse_reads.fastq

cat forward_reads.fastq | wc -l
cat reverse_reads.fastq | wc -l

head -n 4 ../../data/wolf.fastq

cat ../../data/wolf_tutorial/wolf_F.fastq | wc -l
cat ../../data/wolf_tutorial/wolf_R.fastq | wc -l

## trying by replacing space and + in the headers:
grep "^@" forward_reads.fastq | wc -l
cat forward_reads.fastq | wc -l


sed 's/ /_/g' forward_reads.fastq > edited_forward_reads.fastq
sed 's/ /_/g' reverse_reads.fastq > edited_reverse_reads.fastq

head -n 4 edited_forward_reads.fastq
head -n 4 edited_reverse_reads.fastq
illuminapairedend --score-min=20 -r edited_reverse_reads.fastq edited_forward_reads.fastq > ../intermediate_results/edited_merged.fastq
illuminapairedend --score-min=20 -r reverse_reads.fastq forward_reads.fastq > ../intermediate_results/merged.fastq

head -n 4 ../../data/wolf_tutorial/wolf_F.fastq

head -n 4 edited_*.fastq
head -n 4 forward_reads.fastq

awk 'NR>=303 && NR<=310' forward_reads.fastq
awk 'NR>=303 && NR<=310' edited_forward_reads.fastq
awk 'NR>=303 && NR<=310' edited_reverse_reads.fastq



# Trying with 2 other samples first:
cd ../temp && ls

# trying 15_61_S61_R1_001.fastq and 15_61_S61_R2_001.fastq
    illuminapairedend --score-min=20 -r 15_61_S61_R2_001.fastq 15_61_S61_R1_001.fastq > merged_15_61_S62.fastq

    ### trying by removing space in header:
    sed -E '/^@/{s/(^@[^ ]*) .*/\1/}' 15_61_S61_R2_001.fastq > edited_15_61_S61_R2_001.fastq
    sed -E '/^@/{s/(^@[^ ]*) .*/\1/}' 15_61_S61_R1_001.fastq > edited_15_61_S61_R1_001.fastq
    illuminapairedend --score-min=20 -r edited_15_61_S61_R2_001.fastq edited_15_61_S61_R1_001.fastq > merged_edited_15_61_S62.fastq


# trying 180_80_S80_R2_001.fastq and 180_80_S80_R1_001.fastq

illuminapairedend --score-min=20 -r 180_80_S80_R2_001.fastq 180_80_S80_R1_001.fastq > merged_180_80_S80.fastq
cat merged_180_80_S80.fastq

    ### trying by removing space in header:
        sed -E '/^@/{s/(^@[^ ]*) .*/\1/}' 180_80_S80_R2_001.fastq > edited_180_80_S80_R2_001.fastq
        sed -E '/^@/{s/(^@[^ ]*) .*/\1/}' 180_80_S80_R1_001.fastq > edited_180_80_S80_R1_001.fastq
        illuminapairedend --score-min=20 -r edited_180_80_S80_R2_001.fastq edited_180_80_S80_R1_001.fastq > merged_edited_180_80_S80.fastq

head -n 4 180_80_S80_R2_001.fastq

# trying to merge using PEAR tool:
conda deactivate
conda install bioconda::pear -y
pear -f 180_80_S80_R1_001.fastq -r 180_80_S80_R2_001.fastq -o pear_180_80_S80

## trying ngsfilter in the pear asssembled file:
head -n 4 pear_*0.assembled.fastq
conda activate obi

ls 
ngsfilter -t ../tags_list.txt -u ../unidentified.fastq pear_180_80_S80.assembled.fastq > ali.assigned.fastq


# 