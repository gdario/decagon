#!/bin/bash

DATA_PATH='http://snap.stanford.edu/decagon'

while read line;
do
    wget "${DATA_PATH}/${line}"
done < data_files.txt

