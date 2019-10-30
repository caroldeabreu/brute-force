import networkx as nx
from community import *
from glob import *
import numpy as np

files = sorted(glob("k_3/networks/100/mu*/net*/network.dat"))
#files = sorted(glob("k_4/net*/network.dat"))
#files = sorted(glob("k_6/mu*/net*/network.dat"))
mod = []

for filename in files:
    g = nx.read_edgelist(filename)
    part = best_partition(g)
    mod.append(round(modularity(part,g),3))
    #print(filename[:-12],round(modularity(part,g),3))

mod_bins = np.arange(0.64,0.88,0.02)
print(mod,mod_bins)
freqs, bins = np.histogram(mod, bins = mod_bins)

bins = (bins[:-1]+0.02/2)


for i in range(len(freqs)):
    print('modularity: %f - %f \n # networks: %i' % (bins[i]-0.01,bins[i]+0.01, freqs[i]))


