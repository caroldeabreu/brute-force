import pandas as pd
import numpy as np
import glob
import scipy.special
import sys

def generateStatisticsDataframe(N, k, n, incomplete = 0):

    if type(N) != str or len(N) != 3:
        print('N must be a 3 digit string')
        return
        
    if k == 3:
        folder = "k_3/networks/"
    else:
        folder = "k_" + str(k) + "/"
        
    load_heuristics_table = open(folder + 'results/networksinfo' + N + '_'+ str(n)+ '.dat','r')
    
    
    #if N == "100" and n == 5:
    #    print('hi')
    #    heuristic_attacks = pd.read_csv(load_heuristics_table, header = None, sep = ' ', skiprows = 1, index_col = 0, 
    #                             names= ['Q','HBA','MBA'])
    #    heuristic_attacks['CI'] = np.loadtxt('k_3/networks/100/ci.dat', usecols=1) 
        
    #else:
    heuristic_attacks = pd.read_csv(load_heuristics_table, sep = ' ', header = None, skiprows = 1, index_col = 0, 
                                 names= ['Q','HBA','MBA', 'CI'])
    
    #print((heuristic_attacks))
    if k == 3 and N == "100":
        bruteforce_files = sorted(glob.glob(folder+ N + '/mu*/net*/gcn' + str(n) + '.dat'))
    
    if N == '100' and k == 3 and n == 6:
        if n == 6:
            print("hi")
            m = list(map(lambda x: x[17:27], bruteforce_files))
            print(m)
            for item in list(heuristic_attacks.index):
                if item not in m:
                    heuristic_attacks = heuristic_attacks.drop(item, axis = 0)
                    
    elif k == 3 and N == "100":
        bruteforce_files = sorted(glob.glob(folder+ N + '/mu*/net*/gcn' + str(n) + '.dat'))
    elif k ==3 and N != "100":
        bruteforce_files = sorted(glob.glob(folder+ N + '/net*/gcn' + str(n) + '.dat'))
    elif k == 6:
        bruteforce_files = sorted(glob.glob(folder + 'mu*/net*/gcn' + str(n) + '.dat'))
    else:
        bruteforce_files = sorted(glob.glob(folder + 'net*/gcn' + str(n) + '.dat'))
    
    if incomplete != 0:
        if type(incomplete) == str:
            heuristic_attacks = heuristic_attacks.drop(incomplete, axis = 0)
        else:
            for item in incomplete:
                heuristic_attacks = heuristic_attacks.drop(item, axis = 0)
        
        
    #print(bruteforce_files)

    if len(bruteforce_files) == 0:
        print('No files for n = ' + str(n))
        return
    
    #print((bruteforce_files))
    lcc_sizes = [str(i) for i in range(1,int(N) - n + 1)]
    lcc_index = [str(i) for i in range(1,int(N) + 1)]
    
    aux_average = []
    network_names = []
    modularity = []
    bf_average = []
    bf_results = []

    for f in bruteforce_files:
    
        load_bruteforce = np.loadtxt(f, dtype=int)
    
        if N == '120':
            #load_bruteforce = np.append(load_bruteforce, 0)
            net_name = f[17:22]
            print(net_name)
        elif N == '100': 
            if k == 3:
                net_name = f[17:27]
                print(net_name, sum(load_bruteforce))
            if k == 6:
                net_name = f[4:14]
                print(net_name)
            if k ==4:
                net_name = f[4:9]
                print(net_name)
        else:
            net_name = f[4:9]
            
        print(len(bruteforce_files))
        lcc_probability = load_bruteforce/scipy.special.comb(int(N), n)
        print(len(load_bruteforce))
        sum_probs = round(sum(lcc_probability), 1)
        
        if sum_probs != 1.0:
            print(f)
            print(sum(load_bruteforce))
            print('Error in Porbability value: sum_prob = ' + str(sum_probs) )
            pass
        
        bf_average.append(sum(lcc_probability*np.array(lcc_index, dtype = int))/int(N))
        
        network_names.append(net_name)
        modularity.append(round(heuristic_attacks.loc[net_name,:][0],4))
        bf_results.append(pd.Series(load_bruteforce, index=lcc_index))

        
    optimal_points = []

    for ele in bf_results:
        op = float(ele[ele > 0 ].first_valid_index())
        optimal_points.append(op/int(N)) 
            
    statistics = pd.DataFrame({'Q': modularity, 'OP': optimal_points, 'Average': bf_average}, 
                              index = network_names)
    statistics = statistics[['Q', 'OP','Average']]
    print(statistics.iloc[:,1])
    
#     print(network_names)
#     for index in network_names:
#         if index not in list(heuristic_attacks['MBA'].index):
#              print(index)
    
    statistics['AV/OP'] = statistics.iloc[:,2]/statistics.iloc[:,1]
    
    statistics['MBA'] = list(heuristic_attacks['MBA']/float(N))
    
    statistics['HBA'] = list(heuristic_attacks['HBA']/(float(N)))
    
    statistics['CI'] = list(heuristic_attacks['CI']/(float(N)))
    
    statistics = statistics.sort_values(by = 'Q')
    
    return statistics.round(3)

N = sys.argv[1]
n = int(sys.argv[2])
k = int(sys.argv[3])


path = input('new file path: ')

stats = generateStatisticsDataframe(N,k,n)
stats.to_csv(path, index_label = 'names')









