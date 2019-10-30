# Script to record all node removals  that result in the 
# smallest possible largest component

# Import packages
import sys
import itertools # Combinations 
import copy 
import igraph as ig # Graphs
import scipy.special
import time

start = time.monotonic()
N = 80

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

try: 
	n = int(sys.argv[3])
	print("n = ", n)
except:
	print("Number of nodes to remove is missing")



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


c=scipy.special.comb(N,n)

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


i=0

gcvalues = (N+1)*[0]

# Iterate over combinations of n nodes
for comb in itertools.combinations(ig.VertexSeq(G), n):
	if (i >= limit_inf) and (i < limit_sup):
		g = G.copy()
		g.delete_vertices(comb)
		components = g.components()
		GCsize = int(components.giant().vcount()) 
		gcvalues[GCsize] += 1
		if (i == (limit_sup - limit_inf)/2):
			end = time.monotonic()
			print(end-start)
	i=i+1    

with open(path + "/gclist" + section + "n"+str(n)+".txt","w") as f:
	for item in gcvalues[1:]:
		f.write(str(item) + '\n')

end = time.monotonic()

print(end-start)
