# Collective Influence Attack
# Carolina de Abreu Pereira - 01/05/2019

# Returns dataframe containing fraction of vertices removed and 
# relative network size.

# g = igraph graph; n = number of vertices to remove

library("igraph")

# Function to calculate Collective Influence scores for all vertices
collective.influence <- function(g, l){
  len <- length(V(g))
  ci <- vector("integer", len)

  for (v in V(g)){
  	for (i in 1:(l-2)){
  		n.previous <- ego(g, order = i+1, nodes = v)[[1]]
  		n.next <- ego(g, order = i+2, nodes = v)[[1]]
  		neighbors.radius <- n.next[!n.next %in% n.previous]
  	}
  	#neighbors.radius <- ego(g, order = 2, nodes = v)[[1]]
    d <- degree(g, v)
    degrees.neighbors <- degree(g, neighbors.radius)
    ci.v <- (d - 1) * sum(degrees.neighbors - 1)
    ci[v] <- ci.v
    
  }
  return(ci)
}

CI <- function(G, l, n){
  
  sigma_CI <- matrix(nrow = n + 1, ncol = 2)
  sigma_CI[1, 1] <- 0
  sigma_CI[1, 2] <- 1
  g <- G
  N <- length(V(g))
  
  target.list <- integer()
  
  for (i in 1:n) {
    vertex.to.remove <- which.max(collective.influence(g, l))
    target.list <- c(target.list, vertex.to.remove)
    g <- delete_vertices(g, vertex.to.remove)
    sigma_CI[i+1, 1] <- i/N
    sigma_CI[i+1, 2] <- max(clusters(g)$csize)/N
  }
  
  return(list((sigma_CI), target.list))
  
}

CI.nodes <- function(target.list){
	
}
