# Highest Degree Adaptive Attack
# Carolina de Abreu Pereira - 30/04/2019

# Returns dataframe containing fraction of vertices removed and 
# relative network size.

# g = igraph graph; n = number of vertices to remove

#library('igraph')

HDA <- function(G, n){
  # start values
  g <- G
  N <- max(clusters(g)$csize)
  sigma_HDA <- matrix(nrow = n + 1, ncol = 2)
  sigma_HDA[1,1] <- 0.0
  sigma_HDA[1,2] <- 1.0
  
  # start removals of n vertices
  for (i in 1:n){

    # select vertex to remove
    d <- degree(g)
    vertex.to.remove <- which.max(d)
#    print(vertex.to.remove)
    
    
    #check membership of vertex 
    members <- which(clusters(g)$membership == which.max(clusters(g)$csize))
#    print(members)
    
    while (!(vertex.to.remove %in% members)){
      d[vertex.to.remove] = 0
      vertex.to.remove <- which.max(d)
      print(vertex.to.remove)
    }
    
    
    # delete vertex and store values
    g <- delete_vertices(g, vertex.to.remove)
    sigma_HDA[i+1, 1] <- i/N
    sigma_HDA[i+1, 2] <- max(clusters(g)$csize)/N

  }
  
  return(sigma_HDA)
  
}