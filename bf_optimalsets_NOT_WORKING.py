# Script to record all node removals  that result in the 
# smallest possible largest component

# Arguments: 
#	Folder, Section

# Import packages
import sys
import itertools # Combinations 
import copy 
import igraph as ig # Graphs
import json
import numpy as np

try: 
	path = sys.argv[1]
	print("Pasta: ", path)
except: 
	print('Folder name missing')

try: 
	section = sys.argv[2]
	print("Section: ", section, " (of 4)")
except:
	print("Section number missing")

# Open previous results file and get smallest GC value

resultsSize = np.loadtxt(path+"/gcn5.dat").nonzero()[0]
OP = min(resultsSize)

# Read network

try:
	f = open(path+'/network.dat', 'r')
	G= ig.read(f)
	G.delete_vertices(0)
	f.close()

except: 
	f = open(path+'/network.net','r')
	G= ig.read(f, 'pajek')
	f.close()

# Main part: 

# Start constants

c=75287520
i=0

arq = open(path + '/set' + section + '.dat','w')

if section == "1":
	limit_inf = 0
	limit_sup = c/4

elif section == "2":
	limit_inf = c/4
	limit_sup = c/2

elif section == "3":
	limit_inf = c/2
	limit_sup = 3*c/4

elif section == "4":
	limit_inf = 3*c/4
	limit_sup = c

else: 
	print("Choose a value between 1 and 4")

# Iterate over combinations of 5 nodes
for comb in itertools.combinations(ig.VertexSeq(G), 5):
	if (i >= limit_inf) and (i < limit_sup):
		g = G.copy()
		g.delete_vertices(comb)
		components = g.components()
		GCsize = components.giant().vcount()
		
		# Check if GC is OP        

		if GCsize == OP:
			# Clean itertools output 
			combAux = str(comb).split(">, ")
			combAux.remove(combAux[0])
			for item in combAux:
				if item[1] == "'":
					combAux[combAux.index(item)] = item[0]
				else:
					combAux[combAux.index(item)] = item[:2]
        	# Write list of nodes
			arq.writelines((number + ' ') for number in combAux)
			arq.writelines('\n')
			
	i=i+1    

arq.close()
