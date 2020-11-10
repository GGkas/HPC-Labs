#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import argparse

FILE_SEPARATOR = "--------------------\n"
DIR_PATH = os.getcwd()
TIMES_FILE_PATH = DIR_PATH + "/times.txt"

TIMES_LIST=[]
temp_list = []

parser = argparse.ArgumentParser()
parser.add_argument("threads", help="Specify the number of threads used for the kmeans parallelized algorithm", type=int)
args = parser.parse_args()

# Each measurement amps the clusters by 1k.
with open(TIMES_FILE_PATH, 'r') as read_stream:
    for line in read_stream:
        if (line == FILE_SEPARATOR):
            TIMES_LIST.append(temp_list)
            temp_list = []
            continue
        else:
            temp_list.append(float(line))

times_data = np.array(TIMES_LIST).T
times_df = pd.DataFrame(data=times_data, columns=["1K", "2K", "3K", "4K", "5K", "6K", "7K", "8K", "9K", "10K"])

mean_list = []
std_list = []

for col in times_df.columns:
    tempS = times_df[col]
    mean_list.append(tempS.describe(include='all')['mean'])
    std_list.append(tempS.describe(include='all')['std'])

metrics_df = pd.DataFrame({'mean': mean_list, 'std': std_list})

fig = plt.figure(figsize=(20, 12.5))
plt.style.use('seaborn-darkgrid')
plt.errorbar(metrics_df.index, metrics_df['mean'].values, fmt='b--', yerr=metrics_df['std'].values,\
             ecolor='r', elinewidth=1.2, capsize=6)
plt.xticks(range(len(metrics_df.index)))
plt.axes().set_xticklabels(times_df.columns)
plt.title("Time measurements with {} threads active".format(args.threads))
plt.xlabel("Clusters")
plt.ylabel("Time (sec)")
plt.show()