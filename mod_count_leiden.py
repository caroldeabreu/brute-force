import igraph as ig
import leidenalg
from glob import *
import numpy as np

files = sorted(glob("k_3/networks/100/mu*/net*/network.dat"))
#files = sorted(glob("k_4/net*/network.dat"))
#files = sorted(glob("k_6/mu*/net*/network.dat"))
mod = []

for filename in files:
    f = open(filename, 'r')
    try:
        g = ig.read(f, directed = False)
    except:
        g = ig.read(f)
    
    m = g.modularity(leidenalg.find_partition(g, leidenalg.ModularityVertexPartition))
    mod.append(round(m,3))

mod_bins = np.arange(0.52,0.88,0.02)
print(mod,mod_bins)
freqs, bins = np.histogram(mod, bins = mod_bins)

bins = (bins[:-1]+0.02/2)

for i in range(len(freqs)):
    print('modularity: %f - %f \n # networks: %i' % (bins[i]-0.01,bins[i]+0.01, freqs[i]))


