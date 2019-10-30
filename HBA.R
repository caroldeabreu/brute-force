## HBA
HBA<-function(file1,dirc=FALSE,wei=NULL){
  list.targets <- vector('numeric')
  i<-1
  orig_size<-max(clusters(file1)$csize)
  g<-file1
  V(g)$name<-1:vcount(g)
  sigma<-matrix(nrow=vcount(file1)+1,ncol=2)
  sigma[1,1]<-0
  sigma[1,2]<-1
  sigma[vcount(file1)+1,1]<-1
  sigma[vcount(file1)+1,2]<-0
  ### NEW
  V(g)$core<-coreness(g)
  core<-matrix(nrow=vcount(file1)+1,ncol=22)
  c1<-1
  for(c1 in seq(1,22)){
    core[1,c1]<-length(which(coreness(g)==c1))
  }
  ###
#  pb<-txtProgressBar(min = 1, max = vcount(g), style = 3)
#  ptm<-proc.time()[[3]]
  for(i in 1:50){
    target_list<-cbind(V(g)$name,betweenness(g,directed=dirc,weights=wei))
    class(target_list)<-"numeric"
    target_list<-target_list[order(-target_list[,2]),]
    # TARGET -> NODO A RETIRAR
    target<-target_list[1,1]
    list.targets <- c(list.targets, target)
    g<-delete.vertices(g,which(V(g)$name==target))
#    setTxtProgressBar(pb,i)
    sigma[i+1,2]<-max(clusters(g)$csize)/orig_size
    sigma[i+1,1]<-i/vcount(file1)
    ### NEW
    c1<-1
    for(c1 in seq(1,22)){
      core[i+1,c1]<-length(which(coreness(g)==c1))/core[1,c1]
    }
    ###
  }
#  tempo<-proc.time()[[3]]-ptm
  R_HBA<<-sum(sigma[,2])/(((1-min(sigma[,2]))*vcount(file1))+1)
#  P_HBA<<-1/(R_HBA*tempo)
  sigma_HBA<<-sigma
  ### NEW
  c1<-1
  for(c1 in seq(1,22)){
    core[1,c1]<-1
  }
  ###
  kcore<<-core
  g_HBA<<-g
  return(sigma_HBA)
}

# kcore<-kcore[,-14]
# kcore<-kcore[,-16]
# kcore<-kcore[,-16]
# kcore<-kcore[,-16]
# kcore<-kcore[,-17]
# kcore_HBA<-kcore
# 
# 
# 
# plot(kcore_HBA[,17],xlim=c(0,200),ylim=c(0,1),col="white",xlab="q",ylab="M(k)")
# lines(kcore_HBA[,17],xlim=c(0,200),ylim=c(0,1),col=2,xlab="",ylab="")
# lines(kcore_HBA[,16],xlim=c(0,200),ylim=c(0,1),col=3,xlab="",ylab="")
# lines(kcore_HBA[,15],xlim=c(0,200),ylim=c(0,1),col=4,xlab="",ylab="")
# lines(kcore_HBA[,14],xlim=c(0,200),ylim=c(0,1),col=5,xlab="",ylab="")
# lines(kcore_HBA[,13],xlim=c(0,200),ylim=c(0,1),col=6,xlab="",ylab="")
# lines(kcore_HBA[,12],xlim=c(0,200),ylim=c(0,1),col=7,xlab="",ylab="")
# lines(kcore_HBA[,11],xlim=c(0,200),ylim=c(0,1),col=8,xlab="",ylab="")
# lines(kcore_HBA[,10],xlim=c(0,200),ylim=c(0,1),col=9,xlab="",ylab="")
# lines(kcore_HBA[,9],xlim=c(0,200),ylim=c(0,1),col=10,xlab="",ylab="")
# lines(kcore_HBA[,8],xlim=c(0,200),ylim=c(0,1),col=11,xlab="",ylab="")
# lines(kcore_HBA[,7],xlim=c(0,200),ylim=c(0,1),col=12,xlab="",ylab="")
# lines(kcore_HBA[,6],xlim=c(0,200),ylim=c(0,1),col=13,xlab="",ylab="")
# lines(kcore_HBA[,5],xlim=c(0,200),ylim=c(0,1),col=14,xlab="",ylab="")
# lines(kcore_HBA[,4],xlim=c(0,200),ylim=c(0,1),col=15,xlab="",ylab="")
# lines(kcore_HBA[,3],xlim=c(0,200),ylim=c(0,1),col=16,xlab="",ylab="")
# lines(kcore_HBA[,2],xlim=c(0,200),ylim=c(0,1),col=17,xlab="",ylab="")
# lines(kcore_HBA[,1],xlim=c(0,200),ylim=c(0,1),col=18,xlab="",ylab="")

