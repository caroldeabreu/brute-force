library('igraph')
source("~/Dropbox/Mestrado/bruteforce/HBA.R")
source("~/Dropbox/Mestrado/bruteforce/MBA.R")
source("~/Dropbox/Mestrado/bruteforce/CI.R")

#source('C:/Users/Carolina/Dropbox/Mestrado/bruteforce/HBA.R')
#source('C:/Users/Carolina/Dropbox/Mestrado/bruteforce/MBA.R')

N <- 100
n <- 6

l <- 2

#cat("Enter <k> as an integer : \n")
#k <- as.integer(readline(prompt = ""))
k <- 6

m <- 0
HBA.results <- 0
MBA.results <- 0
#HDA.results <- 0
CI.results <- 0

if (k == 3){
	path = paste('~/Dropbox/Mestrado/bruteforce/k_3/networks/', N, sep='')
} else {
	path = paste('~/Dropbox/Mestrado/bruteforce/k_', k, sep='')
}

if (N == 80){
  path = paste('~/Dropbox/Mestrado/bruteforce/k_3/networks/0', N, sep='')
}

cat(path)
setwd(path)

if (N == 100 && k != 4){
 	files <- Sys.glob('mu*/net*/network*')
	subs <- substr(files, 20, 22)
	rows <- substr(files, 1, 10)
 	
} else {
	files <- Sys.glob('net*/network*')
	subs <- substr(files, 15, 17)
	rows <- substr(files, 1, 5)
}

# files <- Sys.glob('net*/network*')
# subs <- substr(files, 15, 17)

for (i in 1:length(files)) {
  print(files[i])
  if (subs[i] == 'dat') {
    g = read_graph(files[i], format = 'edgelist', directed = FALSE)
    g = delete_vertices(g,1)
  } else {
    g = read_graph(files[i], format = 'pajek')
  }

  modularidade <- modularity(cluster_louvain(g),g)
  m[i] <- modularidade
  print(modularidade)

  #print(CI(g,l,n))
  CI.results[i] <- CI(g,l,n)[[1]][n+1,2]*N
#  HDA.results[i] <- HDA(g)[n+1,2]*N
  HBA(g)
  HBA.results[i] <- sigma_HBA[n+1,2]*N
  MBA(g)
  MBA.results[i] <- sigma_MBA[n+1,2]*N
}

#df.old <- read.table('modularity.dat', row.names =substr(files, 1, 10),header = TRUE)
#df.old$Network <- NULL


df.temp <- data.frame(m, HBA.results, MBA.results, CI.results, 
                      row.names = rows)

#df <- merge(df.old, df.temp, by=0)
#row.names(df) <- df$Row.names
#df$Row.names <- NULL
if (N ==80) {
  setwd('~/Dropbox/Mestrado/bruteforce/k_3/networks')
  write.table(df.temp, file = paste('results/networksinfo0', N, '_', n, '.dat', sep=''))
} else if (l == 3){
	write.table(df.temp, file = paste('results/networksinfo', N, '_', n, 'CI3.dat', sep='')) 
} else if (k == 3) {
	setwd('~/Dropbox/Mestrado/bruteforce/k_3/networks')
	write.table(df.temp, file = paste('results/networksinfo', N, '_', n, '.dat', sep=''))
} else {
  write.table(df.temp, file = paste('results/networksinfo', N, '_', n, '.dat', sep=''))
}


