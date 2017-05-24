#!/usr/bin/env python

# COMP90016 Assignment 3
# Lachlan Dryburgh 188607

# Script to convert output of as2.R into a BED format file deletions.bed
# Run as2.R and redirect output to a file.  Run this script with the 
# R output filenmae as a command line argument 

import sys

try:
  f = open(sys.argv[1], 'r')
except IOError:
  print("Can't read file")

out = open("deletions.bed", 'w')

for line in f:
  k = line.split()
  out.write("NC_000913.2\t" + k[2] + "\t " + k[3] + "\t\n")

f.close()
out.close()



