#!/usr/bin/env Rscript

# COMP90016 Assignment 3
# Lachlan Dryburgh 188607 

# Opens the deletions signal text files
# Output should be redirected to a file which will be converted to bed 
# format whith a python script

 
deletions = read.csv("deletion_signal_a2.txt", sep= '\t', header = F)
#par(pch=4)
#plot(x = deletions$V2, y= deletions$V3, xlab = "Left Coordinate", ylab = "Right Coordinate", main = "2 Standard deviations")

#deletions3 = read.csv("deletion_signal_a3.txt", sep= '\t', header = F)
#plot(x = deletions3$V2, y = deletions3$V3, xlab = "Left Coordinate", ylab = "Right Coordinate", main = "3 Standard deviations")

# Construct a distance matrix for the reads
# Distance between each pair of reads is the maximum of the the 
# distance between the left ends and the right ends
distance_matrix = dist(deletions[,2:3], method = "maximum") 

# Hierachial clustering with complete linkage
# the distance between the clusters is the furthest distance pair 
clust = hclust(distance_matrix, method = "complete")
#plot(clust)

#clust3 = hclust(dist(deletions3[,2:3], method = "maximum"))

# Frag length is the fragment length
frag_length = 300

# Cut the tree at a height of the fragment length
# Since we used the maximum distance and complete linkage
# no cluster will contain reads that are more than a fragment length apart
cut = cutree(clust, h=frag_length)

# Number of clusters
n = max(cut)

#cut3 = cutree(clust3, h=frag_length)

#n3 = max(cut3)

# Size of each cluster
c_size = lapply(1:n, function(x) sum(cut==x))
#c_size3 = lapply(1:n3, function(x) sum(cut3==x))

deletions[,4] = cut
#deletions3[,4] = cut3

#added a max delete length to get rid of some very long very wrong deletes
max_delete_length = 100000000 #None

# For each cluster with a size more than 5
# output the maximum of  the left reads and the minimum right reads
count2 = 0
for( i in 1:n)
{
  if (c_size[i]>5)
  {
    count2 = count2 + 1 
    cl = deletions[deletions[,4]==i,]
    start = max(cl[,2])
    end = min(cl[,3])
    if ((end-start)<max_delete_length)
    {
      print(c(i, max(cl[,2]), min(cl[,3])))
    }
  }
}

#count3 = 0
#for( i in 1:n3)
#{
#  if (c_size3[i]>5)
#  {
#    count3 = count3 + 1
#    cl = deletions3[deletions3[,4]==i,]
#    start = max(cl[,2])
#    end = min(cl[,3])
#    if ((end-start)<max_delete_length)
#    {
#      print(c(i, max(cl[,2]), min(cl[,3])))
#    }
#  }
#}

