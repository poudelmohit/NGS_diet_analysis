    cd -p thesis_project/exploring_obitools && cd $_

# installing conda:
    mkdir tools && cd $_
    wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    chmod +x Anaconda3-*.sh
    bash Anaconda3-*.sh -b -p ~/anaconda3 # running installer
    ~/anaconda3/bin/conda init # adding to PATH
    source ~/.bashrc # restarting source to apply changes
    conda --version # verifying installation

# installing obitools in a dedicated environment:
    
    conda create --name obi python=2.7 -y
    conda activate obi

    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

    conda install obitools -y
    
    obigrep -h # just to verify installation


# obtaining sample_data:
    cd .. && ls
    
    mkdir data && cd $_
    wget https://pythonhosted.org/OBITools/_downloads/wolf_tutorial.zip
    
## Exploring data:
    cd wolf_tutorial && ls
   
    wolf_F.fastq: the fastq files containing forward fastq reads from 4 fecal samples.
    wolf_R.fastq: the fastq files containig reverse fastq reads from 4 fecal samples.
    cat wolf_diet_ngsfilter.txt : primers and tags for each sample
    cat db_v05_r117.fasta # reference database extracted from the release 117 of EMBL using ecoPCR
    ls embl_* # NCBI taxonomy formatted in ecoPCR format

# Merging pair end reads:
    illuminapairedend --score-min=40 -r wolf_R.fastq wolf_F.fastq > ../wolf.fastq
    # Here, if the alignment score is below 40, the sequences are not aligned but concatenated; 
    and in the sequence headers, mode is set to joined, instead of alignment

# Removing unaligned sequence records:
    obigrep -p 'mode!="joined"' ../wolf.fastq > ../wolf.ali.fastq
    # using -p is requied for python expression which looks for reads with mode not equal to joined !!

    # looking at the first sequence of aligned read:
    obihead --without-progress-bar -n 1 ../wolf.ali.fastq
    # using --without-progress-bar gives clearer view

# Assigning each sequence record to the corresponding sample/marker combination:
   
    ngsfilter --h
    ## see more at: [ngsfilter](https://pythonhosted.org/OBITools/scripts/ngsfilter.html)

    ngsfilter -t wolf_diet_ngsfilter.txt -u ../unidentified.fastq ../wolf.ali.fastq > ../wolf.ali.assigned.fastq

    # here, -t is to denote sample containing tags and primers record
    
    # -u creates a file containing all sequence records that are not assigned to markers or tags
    
    # wolf.ali.assigned.fastq is the new output file containg all sequences that are assigned to a sample/marker combination; 
    # Also in the header it contains information about sample,primers, tags,etc. 
    # The sequences has barcode in it, but not primers and tags. Primers and tags are already removed by ngsfilter !!

    head -n 4 ../wolf.ali.assigned.fastq
    
# Dereplicating duplicate reads:

    obiuniq -m sample ../wolf.ali.assigned.fastq > ../wolf.ali.assigned.uniq.fasta

    # -m sample is to keep the information of the samples of origin for each unique sequence
    
    head -n 3 ../wolf.ali.assigned.uniq.fasta

    # in the header, merged_sample and count keys are added. 
    # To keep only this information in the sequence header:

    obiannotate -k count -k merged_sample ../wolf.ali.assigned.uniq.fasta > ../wolf_annotated_uniq.fasta
    
    head -n 10 ../wolf_annotated_uniq.fasta

# I noticed broken sequence here, which I will treat (...) later !!

# Denoising the sequene dataset:

    # The plan here is to discard rare sequences that likely come out of PCR and/or sequencing errors.

### Getting count statistics:
    obistat -c count ../wolf_annotated_uniq.fasta | sort -nk1 > ../count_statistics.txt
    head -n 10 ../count_statistics.txt

    # The dataset contains 3504 sequences occurring only once
    # 228 sequences are occurring twice;
    # 47 different sequences are occurring 6 times, and so on:

### Keeping only sequenesc that have count >= 10; and length < 80 bp:
    # decision of <80 bp depends upon marker (do literature review):
    
    # Here, amplified 12S-V5 barcode must have length around 100 bp.
    
    # Need to find similar length for cytb and trnL !!

    obigrep -l 80 -p 'count>=10' ../wolf_annotated_uniq.fasta > ../wolf_annotated_uniq_trimmed.fasta

### Cleaning for PCR/sequencing errors:
    # !! Learn more about *obiclean* program [from here](https://pythonhosted.org/OBITools/scripts/obiclean.html)

    obiclean -s merged_sample -r 0.05 -H ../wolf_annotated_uniq_trimmed.fasta > ../wolf_cleaned.fasta




    
    
