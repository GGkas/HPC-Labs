#!/bin/bash

touch log_file.txt
sh -c "make all" &

for i in {1...12}
do
	./$1 >> log_file.txt
done
