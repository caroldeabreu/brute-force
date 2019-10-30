import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from glob import glob
from community import *

pos = np.arange(0.7,0.85, 0.02)

fig, ax = plt.subplots()

for p in pos:
    ax.axvline(p, lw = 0.5, color = 'black')

m = []

for folder in glob('net*/'):
    try: 
        g = nx.read_edgelist(folder + 'network.dat')
        part = best_partition(g)
        m.append(round(modularity(part, g), 5))
    except:
        pass

ax.set_ylim([0.67, 0.85])
ax.set_xlim([0.67, 0.85])

ax.scatter(m,m)
print(glob('net*'))
print(sorted(m))
plt.show()