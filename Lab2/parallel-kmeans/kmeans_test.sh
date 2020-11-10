#!/bin/bash

# NON-MANDATORY OPTIONS
set -e
#set -u
set -o pipefail

# Useful variables

EXEC_DIR="`pwd`"
IMAGE_DIR="${EXEC_DIR}/Image_data/"

if [ $# -lt 1 ]; then
	echo "Exiting..."
	exit 0
fi

make all

while getopts 'e:t:n:c:sp' OPTION; do
	case "$OPTION" in
		t)
			THRESHOLD=${OPTARG}
			;;
		n)
			# How many system threads to use
			export OMP_NUM_THREADS=${OPTARG}
			;;
		c)
			# How many clusters for kmeans algorithm
			NUM_CLUSTERS=${OPTARG}
			;;
		e)
			# How many times to run the executable
			EPOCHS=${OPTARG}
			;;
		s)
			# Compile with sequential code
			sed -i -e '/DPAR/s/DPAR/DSEQ/' Makefile
			make clean
			make all
			;;
		p)
			# Compile with parallel code
			sed -i -e '/DSEQ/s/DSEQ/DPAR/' Makefile
			make clean
			make all
			;;
		?)
			echo "Usage: $(basename $0) [-e <execution_times>] [-t <threshold>] [-n <num_threads>] [-c <num_clusters>] [-s/p]"
			exit 1
			;;
	esac
done
shift "$(($OPTIND -1))"

for (( k = 1; k <= 10; k++))
do
	printf "\nConfig: %d clusters\n\n" "$NUM_CLUSTERS"
	for (( i = 1; i <= $EPOCHS; i++ ))
	do
		echo "Running program..."
		bash -c "${EXEC_DIR}/seq_main -q -o -b -n ${NUM_CLUSTERS} -i ${IMAGE_DIR}texture17695.bin >> execution_logs.data"
	done

	COMP_TIMES=`cat execution_logs.data | grep "Computation" | awk -F'=' '{print $2}'`
	echo ${COMP_TIMES} | grep -o '[0-9]\.[0-9]*' >>times.txt
	echo "--------------------" >>times.txt
	rm -f *.data
	NUM_CLUSTERS=$(($NUM_CLUSTERS + 1000))
done
