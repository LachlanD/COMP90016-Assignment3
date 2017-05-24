#!/usr/bin/env python

# COMP90016 Assignment 3
# Lachlan Dryburgh 188607

import sys
import pysam
import numpy


try:
  samfile = pysam.AlignmentFile(sys.argv[1], 'rb')
except IOError:
  print("Can't read file: ", samfile)

if len(sys.argv) > 2:
  try:
    a = float(sys.argv[2])
  except IOError:
    print(a, " is not a valid number")
else:
  a = 2

# Calculate Mean insert length
c = 0
size = []
for read in samfile.fetch(until_eof=True):
  c+=1
  # Stop after 10000 
  if c > 10000:
    break
  
  # Check for proper pair 
  # Count only the positive of the pair
  if read.is_proper_pair and read.template_length > 0:
    size.append(read.template_length)
  #if c < 5:
    #print(read)


mean = numpy.mean(size)
sd = numpy.std(size)

print("mean: " + str(mean))
print("sd: " + str(sd))

c = 0
deletes = []
for read in samfile.fetch():
  c += 1
  # Keep reads that are longer than expected
  # Note finding the mate now will mess up the iterator, do that later
  if (read.template_length > (mean + a*sd)):
    deletes.append(read)

print("Number of reads: " + str(c))

filename = "deletion_signal_a" + str(int(a)) + ".txt"
out = open(filename, 'w')


pairs = []
for d in deletes:
  mate = samfile.mate(d)
  r1 = d.reference_end
  # Get the mate read
  r2 = mate.reference_start
  # Check the mate pairs are on opposing strands
  if(mate.is_reverse != d.is_reverse):
    pairs.append((d.query_name,r1,r2))
    out.write(d.query_name + '\t' + str(r1) + '\t' + str(r2) + '\n')
    #print(str(d.is_reverse) + '\t' + str(mate.is_reverse) + '\t' + str(d.template_length) + '\t' + str(d.query_length + r2 - r1 + mate.query_length) + "\n")

out.close()
samfile.close()


