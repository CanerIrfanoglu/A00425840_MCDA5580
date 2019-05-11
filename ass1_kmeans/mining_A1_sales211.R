

sales211 <- read.csv("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/sales211.csv", header = FALSE)
# 1,762,082 vs 17 takes around 30 secs to read

sales_agg <- read.csv("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/sales_agg.csv", header = FALSE)
names(sales_agg) <- c("customer_sk", "spending", "visits")
sales_agg$customer_sk <- as.character(sales_agg$customer_sk)
sales_agg_sub <- sales_agg[1:50,]
lo <- 2
hi <- 20
size <-  (hi-lo+1)
err <- array(2*size, dim= c(size,2))

for(i in lo:hi){
    rowNum = i-lo+1
    err[rowNum, 1] <- i
    err[rowNum, 2] <- kmeans(sales_agg_sub[,2:3],i,100)$tot.withinss
    
}

