###Figure S1A,1B
pdf("sequence_depth_hist.pdf",width = 8,height = 4)
par(mfrow=c(1,2))
raw<- read.table("raw_depth.txt",header = T)
raw_x <- as.numeric(raw[,1])
hist(raw_x,xlab = "Raw data size (Gbp)",main = "",breaks = 30,xlim = c(40,160))
raw_yfit <- density(raw_x)$y*length(density(raw_x)$x)*7
lines(density(raw_x)$x ,raw_yfit,col = rgb(0,0,0,0.7), lwd=2)
clean <- read.table("clean_depth.txt",header = T)
clean_x <- as.numeric(clean[,1])
hist(clean_x,xlab = "Clean data size (Gbp)",main = "",breaks = 50 ,xlim = c(0,5))
clean_yfit <- density(clean_x)$y*length(density(clean_x)$x)*0.15
lines(density(clean_x)$x ,clean_yfit,col = rgb(0,0,0,0.7), lwd=2)
dev.off()