import numpy as np
import sys
import glob

try: 
	path = sys.argv[1]
	print("Pasta: ", path)
except: 
	print('Folder name missing')

try: 
	n = str(sys.argv[2])
	print("n: ", n)
except: 
	print('n missing')


arq = open(path + '/ops_' + n + '.dat', 'w')

print(path[-1])

try:
    if path[-1] == '6' or path[4] == 'n':
        f = sorted(glob.glob(path + '/*/*/gcn' + n + '.dat'))
        mu = True
except:
    f = sorted(glob.glob(path + '/*/gcn' + n + '.dat'))
    mu = False

print(f)

for i, name in enumerate(f):
    print(name)
    op = np.loadtxt(f[i])
    index = min(op.nonzero()[0])
    op = str(int(op[index]))
    if mu:
        name = f[i][-19:-9]
    else:
        name = f[i][-14:-9]
    
    print(name, op)

    arq.write(name + ' ' + op + '\n')

arq.close()