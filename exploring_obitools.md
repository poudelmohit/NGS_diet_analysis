    cd -p thesis_project/exploring_obitools && cd $_

# Installing conda:
    mkdir tools && cd $_
    wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
    chmod +x Anaconda3-*.sh
    bash Anaconda3-*.sh -b -p ~/anaconda3 # running installer
    ~/anaconda3/bin/conda init # adding to PATH
    source ~/.bashrc # restarting source to apply changes
    conda --version # verifying installation

# Installing obitools in a dedicated environment:
    
    conda create --name obi python=2.7 -y
    conda activate obi

    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

    conda install obitools -y
    
    obigrep -h # just to verify installation


# Obtaining sample_data:
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
   
    
##### see more at: [ngsfilter](https://pythonhosted.org/OBITools/scripts/ngsfilter.html)
    ngsfilter --h
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

    # In the header, merged_sample and count keys are added; To keep only this information in the sequence header:

    obiannotate -k count -k merged_sample ../wolf.ali.assigned.uniq.fasta > ../wolf_annotated_uniq.fasta
    
    head -n 10 ../wolf_annotated_uniq.fasta

###### I noticed broken sequence here, which I will treat later (if required) !!

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
###### Learn more about *obiclean* program [from here](https://pythonhosted.org/OBITools/scripts/obiclean.html)

    obiclean -s merged_sample -r 0.05 -H ../wolf_annotated_uniq_trimmed.fasta > ../wolf_cleaned.fasta

##### I need to figure out what is -s merged_sample parameter and -r 0.05 (for later) 

# Taxonomic assignment:

### Building reference database:

    # In tutorial, they have used ecoPCR to simulate a PCR and extract all sequences from EMBL\
     that may be amplified in silico by the selected primers !!!
    
#### Here is what they have done for reference database creation (copied from the tutorial):
    
##### The full list of steps for building this reference database would then be:

- Download the whole set of EMBL sequences ([available here](ftp://ftp.ebi.ac.uk/pub/databases/embl/release/))

- Download the NCBI taxonomy ([available here](ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz))

- Format them into the [ecoPCR](https://pythonhosted.org/OBITools/scripts/ecoPCR.html) format (see [obiconvert](https://pythonhosted.org/OBITools/scripts/obiconvert.html) for how you can produce ecoPCR compatible files)

- Use ecoPCR to simulate amplification and build a reference database based on putatively amplified barcodes together with their recorded taxonomic information
    
- Complete code to download similar ref database is available [here](https://pythonhosted.org/OBITools/wolves.html#build-a-reference-database)

## Assigning each sequence to a taxon:

    ecotag -d embl_r117 -R db_v05_r117.fasta ../wolf_cleaned.fasta > ../wolf_cleaned_tagged.fasta
    head -n 2 ../wolf_cleaned_tagged.fasta

    # Several new keys&values added here are: best match, best identity, taxid and scientific name

### Removing unrequired attributes:
      
    obiannotate  --delete-tag=scientific_name_by_db --delete-tag=obiclean_samplecount \
        --delete-tag=obiclean_count --delete-tag=obiclean_singletoncount \
        --delete-tag=obiclean_cluster --delete-tag=obiclean_internalcount \
        --delete-tag=obiclean_head --delete-tag=taxid_by_db --delete-tag=obiclean_headcount \
        --delete-tag=id_status --delete-tag=rank_by_db --delete-tag=order_name \
        --delete-tag=order ../wolf_cleaned_tagged.fasta > ../wolf_cleaned_tagged_annotated.fasta

#### Checking the first sequence:

    head -n 4 ../wolf_cleaned_tagged_annotated.fasta

    obisort -k count -r ../wolf_cleaned_tagged_annotated.fasta > \
    ../wolf_cleaned_tagged_annotated_sorted.fasta

    head -n 3 ../wolf_cleaned_tagged_annotated_sorted.fasta

# Saving result to a clean tsv file:
    mkdir ../../results
    obitab -o ../wolf_cleaned_*_sorted.fasta > ../../results/wolf_diets.tab
    cd ../../results && ls
    