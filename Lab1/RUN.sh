#!/bin/bash

touch log_file.log
LOGFILE="log_file.log"
TEMPFILE="temp.data"
sh -c "make all"

echo -n "Progress: "


for i in {1..12}
do
	printf '#'
	./$1 &>> $LOGFILE
done
printf '\n'

# Clean up the output of sobel_orig executable for further use
grep "Total time =" ${LOGFILE} > ${TEMPFILE}
awk -F'=' '{print $2}' ${TEMPFILE} > times.txt

grep "PSNR" ${LOGFILE} > ${TEMPFILE}
awk -F':' '{print $2}' ${TEMPFILE} > psnr.txt

rm -f ${LOGFILE} ${TEMPFILE}

sh -c "make clean"
