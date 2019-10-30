import numpy as np
import matplotlib.pyplot as plt

n = str(input('n? '))
N = str(input('N? '))

arq = 'networksinfo'+ N +'_'+ n + '.dat'

m = np.loadtxt(arq, skiprows = 1, usecols = 1)


hba = np.loadtxt(arq, skiprows = 1, usecols = 2)
mba = np.loadtxt(arq, skiprows = 1, usecols = 3)
ci = np.loadtxt(arq, skiprows = 1, usecols = 4)

pos = np.arange(0.7,0.85, 0.02)

fig, ax = plt.subplots()

if input('hba? (y/n) ') == 'y': 
    ax.scatter(m, hba, label='HBA', s=10)
if input('mba? (y/n) ') == 'y': 
    ax.scatter(m, mba, label='MBA', s=10)
if input('ci? (y/n) ') == 'y': 
    ax.scatter(m, ci, label='CI', s=10)

for p in pos:
    ax.axvline(p, lw = 0.5, color = 'black')

ax.legend()

ax.set_xlabel("Modularity")
ax.set_ylabel("Fragmentation Strategy")

plt.show()
