t <- read.csv("k_3/networks/results/data_100_5.csv")
df3 <- as.data.frame(t)
t <- read.csv("k_6/data_100_5.csv")
df6 <- as.data.frame(t)
t <- read.csv("k_4/networksinfo100_5.dat", sep=" ")
df4 <- as.data.frame(t)


plot(df6$Q, df6$OP, col = "red", xlab="Q", ylab="OP", pch=19, ylim = c(0.1,1.0))
par(new=TRUE)
points(df3$Q, df3$OP,xlab="",ylab="", pch=19)

legend("topright", title="<k>",
	   c("3","6"), fill=c("black", "red"), bty="n")
