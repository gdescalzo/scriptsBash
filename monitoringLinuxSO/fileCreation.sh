#!/bin/bash

# This script create 4 files on the /tmp/fullFolder directory.
# Four files with random size.
# It's usefull for testing propose

folder="/tmp/fullFolder"
folderSizes=$(du -hs $folder | awk '{ print $1 }')
runsTimes=$(date +"%Y/%m/%d - %H:%M:%S")
lastFile=$(find "$folder"/ -maxdepth 1 -name '*' | sort  -n -t - -k2  | tail -n 1 | awk '{ print $4 }'  FS='/')
indexFile=$(echo $lastFile | awk '{ print $2}' FS='-' | sort |awk '{ print $1 }' FS='.')
totalFiles=$(ls -1 "$folder"/ | wc -l)
from=0
to=0
min=1      # min size (MB)
max=30     # max size (MB)

((from="$indexFile" + 1))
((to="$indexFile" + 4))

for fileNumber in $(eval "echo {$from..$to}"); 
    do 
        dd if=/dev/urandom of=$folder/file-"$fileNumber".txt bs=1MB count=$(($RANDOM%max + $min));
done 

totalFiles=$(ls -1 "$folder"/* | wc -l)
lastFile=$(find "$folder"/ -maxdepth 1 -name '*' | sort  -n -t - -k2  | tail -n 1 | awk '{ print $4 }'  FS='/')
folderSizes=$(du -hs $folder | awk '{ print $1 }')

echo ""
echo "$runsTimes" : The folder "'$folder'" has a size of "'$folderSizes'"
echo El total de archivos es: "'$totalFiles'"
echo El ultimo archivo creado es: "'$lastFile'"