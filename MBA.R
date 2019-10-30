## MBA
MBA<-function(file1,md=c("all"),wei=NULL,dirc=FALSE){
  i<-1
  j<-1
  orig_size<-max(clusters(file1)$csize)
  g<-file1
  V(g)$name<-1:vcount(g)
  class(V(g)$name)<-"numeric"
  sigma<-matrix(nrow=vcount(file1)+1,ncol=2)
  sigma[1,1]<-0
  sigma[1,2]<-1
  ### NEW
  #V(g)$core<-coreness(g)
  core<-matrix(nrow=vcount(file1)+1,ncol=22)
  c1<-1
  for(c1 in seq(1,22)){
  #  core[1,c1]<-vcount(induced.subgraph(g,which(V(g)$core == c1)))
    core[1,c1]<-length(which(coreness(g)==c1))
  }
  ###
  target_list<-cbind(V(g)$name,betweenness(g,directed=dirc,weights=wei))
  class(target_list)<-"numeric"
  target_list<-target_list[order(-target_list[,2]),]
  #############################
  commu<-multilevel.community(g)
  E(g)$cross<-crossing(commu,g)
  g1<-subgraph.edges(g,which(E(g)$cross==TRUE))
  target_list<-subset(target_list,target_list[,1]%in%as.numeric(V(g1)$name)) 
  pb1<-txtProgressBar(min = 1, max = nrow(target_list), style = 3)
  ptm<-proc.time()[[3]]
  for (j in 1:(nrow(target_list))){
    act<-degree(g1,v=which(V(g1)$name==target_list[j,1]))
    if (act>0){
      g1<-delete.vertices(g1,which(V(g1)$name==target_list[j,1]))
    }   
    else{
      target_list[j,1]<--1
    }
    setTxtProgressBar(pb1,j)
  }
  target_list<-subset(target_list,target_list[,1]!=-1)
 # target_list<-head(target_list,n=6)
  cat("\n Target list: Ok!")
  #############################
  pb<-txtProgressBar(min = 1, max = nrow(target_list), style = 3)
 # for(i in 1:(nrow(target_list))){
  repeat{
    bgcomp<-induced.subgraph(g,which(clusters(g)$membership == which.max(clusters(g)$csize)))
    tg_list<-subset(target_list,target_list[,1]%in%V(bgcomp)$name)
    if (length(tg_list)==0){
      break
    }
    target<-tg_list[1,1]
    g<-delete.vertices(g,which(V(g)$name==target))
    setTxtProgressBar(pb,i)
    sigma[i+1,2]<-max(clusters(g)$csize)/orig_size
    sigma[i+1,1]<-i/vcount(file1)
    ### NEW
    c1<-1
    for(c1 in seq(1,22)){
    #  core[i+1,c1]<-vcount(induced.subgraph(g,which(V(g)$core == c1)))/core[1,c1]
      core[i+1,c1]<-length(which(coreness(g)==c1))/core[1,c1]
    }
    ###
    i<-i+1
  }
  ### NEW
  core[1,]<-1
  ###
  sigma<-subset(sigma,sigma[,1]!="NA")
  tempo<-proc.time()[[3]]-ptm
  sigma_MBA<<-sigma
  R_MBA<<-sum(sigma[,2])/((1-min(sigma[,2]))*vcount(file1))
  P_MBA<<-1/(R_MBA*tempo)
#  core<-subset(core,core[2,]!="NaN")
  kcore<<-core
  g_MBA<<-g
}
# 
# kcore<-kcore[,-14]
# kcore<-kcore[,-16]
# kcore<-kcore[,-16]
# kcore<-kcore[,-16]
# kcore<-kcore[,-17]
# kcore<-head(kcore,n=200)
# kcore_MBA<-kcore
# 
# 
# plot(kcore_MBA[,17],xlim=c(0,200),ylim=c(0,1),col="white",xlab="q",ylab="M(k)")
# lines(kcore_MBA[,17],xlim=c(0,200),ylim=c(0,1),col=2,xlab="",ylab="")
# lines(kcore_MBA[,16],xlim=c(0,200),ylim=c(0,1),col=3,xlab="",ylab="")
# lines(kcore_MBA[,15],xlim=c(0,200),ylim=c(0,1),col=4,xlab="",ylab="")
# lines(kcore_MBA[,14],xlim=c(0,200),ylim=c(0,1),col=5,xlab="",ylab="")
# lines(kcore_MBA[,13],xlim=c(0,200),ylim=c(0,1),col=6,xlab="",ylab="")
# lines(kcore_MBA[,12],xlim=c(0,200),ylim=c(0,1),col=7,xlab="",ylab="")
# lines(kcore_MBA[,11],xlim=c(0,200),ylim=c(0,1),col=8,xlab="",ylab="")
# lines(kcore_MBA[,10],xlim=c(0,200),ylim=c(0,1),col=9,xlab="",ylab="")
# lines(kcore_MBA[,9],xlim=c(0,200),ylim=c(0,1),col=10,xlab="",ylab="")
# lines(kcore_MBA[,8],xlim=c(0,200),ylim=c(0,1),col=11,xlab="",ylab="")
# lines(kcore_MBA[,7],xlim=c(0,200),ylim=c(0,1),col=12,xlab="",ylab="")
# lines(kcore_MBA[,6],xlim=c(0,200),ylim=c(0,1),col=13,xlab="",ylab="")
# lines(kcore_MBA[,5],xlim=c(0,200),ylim=c(0,1),col=14,xlab="",ylab="")
# lines(kcore_MBA[,4],xlim=c(0,200),ylim=c(0,1),col=15,xlab="",ylab="")
# lines(kcore_MBA[,3],xlim=c(0,200),ylim=c(0,1),col=16,xlab="",ylab="")
# lines(kcore_MBA[,2],xlim=c(0,200),ylim=c(0,1),col=17,xlab="",ylab="")
# lines(kcore_MBA[,1],xlim=c(0,200),ylim=c(0,1),col=18,xlab="",ylab="")
