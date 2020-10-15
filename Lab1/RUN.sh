#!/bin/bash

touch log_file.txt
LOGFILE="log_file.txt"

sh -c "make all"

echo -n "Progress: "


for i in {1..12}
do
	printf '#'
	./$1 &>> $LOGFILE
done
printf '\n'
sh -c "make clean"
