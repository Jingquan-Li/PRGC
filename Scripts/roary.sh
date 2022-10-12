#!/bin/bash
####roary install
#install mamba 
conda install -c conda-forge mamba

conda config --add channels r
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
mamba install roary
