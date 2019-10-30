from glob import *
import numpy as np
import matplotlib.pyplot as plt
#import json

# nodes removed
n = input('n? ')

# size of network
N=int(input('N?'))

# self explanatory
yn = input('selected networks (n) or all networks (y)?')
if yn == 'y':
    path = input('networks path: ')
    folders = sorted(glob(path))
elif yn == 'n':
    path = input('networks: ')
    folders = sorted(path.split())

print(len(folders), folders)

# iterate over network folders
for folder in folders:
    try:
        # get the 4 parts
        files = glob(folder + '/gclist*' + "n" + n + '*.txt' )
        #files = sorted(glob(folder + "/gclist*"))
        
        lists = [[] for i in range(len(files))]
    
        print(files)
        for file in files:
            # read files
            with open(file, "r") as f:
                for line in f.readlines():
                    lists[files.index(file)].append(int(line))
    
        for i in range(len(lists)):
            lists[i] = np.array(lists[i], dtype = int)
        
        # sum values
        finalList = list(sum(lists))
        
        # check length
        if len(finalList) < N:
            finalList.append(0)
        
        # save new file
        name = folder + '/gcn' + n + '.dat'
        
        with open(name, "w") as f:
            for item in finalList:
                f.write(str(item) + '\n')
    
    except:
        pass