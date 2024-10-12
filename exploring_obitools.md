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
    conda create --name obitools_env python=2.7 -y
    conda activate obitools_env
    conda install bioconda::obitools

    wget https://pythonhosted.org/OBITools/_downloads/get-obitools.py
    chmod +x *.py
    
    python get-obitools.py


    conda create --name obi python=2.7 -y
    conda activate obi

    conda config --add channels defaults
    conda config --add channels bioconda
    conda config --add channels conda-forge

    conda install obitools -y
    
    obigrep -h # just to verify installation


    


    
    
