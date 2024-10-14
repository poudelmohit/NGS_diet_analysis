# Here I am exploring more about the data itself:


## Is the unique_barcodes present in the tutorial data?
    
    grep -i 'aattaac' wolf_F.fastq | wc -l     
    grep -i 'aattaac' wolf_R.fastq | wc -l
    # present in 9076 reads in both fastq files !!

    grep -i 'gaagtag' wolf_F.fastq | wc -l # in 9736
    grep -i 'gaagtag' wolf_R.fastq | wc -l # in 9734

    grep -i 'gaatatc' wolf_F.fastq | wc -l # in 14733
    grep -i 'gaatatc' wolf_R.fastq | wc -l # in 14723

    grep -i 'gcctcct' wolf_F.fastq | wc -l # in 9908
    grep -i 'gcctcct' wolf_R.fastq | wc -l # in 9825

## Also, checking if there is 'marker sequences' or not:
    grep -i -E 'TTAGATACCCCACTATGC' wolf_F.fastq | wc -l # 21687 reads matched
    grep -i -E 'TTAGATACCCCACTATGC.*TAGAACAGGCTCCTCTAG' wolf_F.fastq
    
    grep -i -E 'TAGAACAGGCTCCTCTAG' wolf_F.fastq | wc -l # 21553 match
    grep -n --color=always -i -E 'TAGAACAGGCTCCTCTAG' wolf_F.fastq

    head -n 4 wolf_F.fastq


# Checking the format after ngsfilter step:
head -n 4 data/wolf.ali.assigned.fastq

    





