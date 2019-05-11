library(dplyr)
library(ggplot2)
library(GGally)
library(DMwR)

source("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/ass1_kmeans/mining_A1_classwork.R")
# Importing withinSSrange function for kmeans
# withinSSrange returns the total sum of distances for given range of low:high clusters 
################################# READING DATA #################################################### 

#sales211 <- read.csv("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/ass1_kmeans/sales211.csv", header = FALSE)


# 1,762,082 vs 17 takes around 30 secs to read
#sales211 1,762,083 | 565,979 is 1 ~ 32%
#sales219 3,678,038 | 1,342,702 is 1  ~ 36%

# USE ca_irfanoglu;
# CREATE TABLE productCluster AS
# SELECT ITEM_SK AS ITEM_ID,
# SUM(SELLING_RETAIL_AMT) AS TOTAL_REVENUE,
# COUNT(ITEM_SK) AS VISITS_PURCHASED,
# COUNT(DISTINCT( CUSTOMER_SK)) AS DISTINCT_CUSTOMERS,
# AVG( SELLING_RETAIL_AMT / ITEM_QTY) AS AVG_PRICE
# FROM dataset01.sales211
# WHERE CUSTOMER_SK > 1 AND ITEM_QTY > 0 AND SELLING_RETAIL_AMT > 0
# GROUP BY ITEM_SK
# ORDER BY TOTAL_REVENUE DESC
# LIMIT 2000;

# PRODUCT QUERY
product <- read.csv("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/ass1_kmeans/productCluster.csv", header = TRUE)


# USE ca_irfanoglu;
# CREATE TABLE customerCluster AS
# SELECT CUSTOMER_SK,
# SUM(SELLING_RETAIL_AMT) AS TOTAL_REVENUE,
# SUM(ITEM_QTY) AS TOTAL_ITEMS,
# COUNT(DISTINCT(ITEM_SK)) AS DISTINCT_ITEMS,
# COUNT(DISTINCT(TRANSACTION_RK)) AS TIMES_VISITED,
# MAX(DATE) as MOST_RECENT_VISIT,
# SUM(SELLING_RETAIL_AMT) / NULLIF(COUNT(DISTINCT(TRANSACTION_RK)),0) AS AVG_SPENT_PER_VISIT
# FROM dataset01.sales211
# WHERE CUSTOMER_SK > 1 AND ITEM_QTY > 0 AND SELLING_RETAIL_AMT > 0
# GROUP BY CUSTOMER_SK
# ORDER BY TOTAL_REVENUE DESC
# LIMIT 2000;

# CUSTOMER QUERY 
customer <- read.csv("/Users/Caner/Desktop/SMU_Class/Data_Mining_5580/ass1_kmeans/customerCluster.csv", 
                     header = TRUE,
                     stringsAsFactors = FALSE)


####################################################################################################

names(sales211) <- c("TRANSACTION_RK", "CALENDAR_DT", "DATE", "TIME", "TRANSACTION_TM", 
                     "ITEM_SK", "RETAIL_OUTLET_LOCATION_SK", "POS_TERMINAL_NO", "CASHIER_NO", 
                     "ITEM_QTY", "ITEM_WEIGHT", "SALES_UOM_CD", "SELLING_RETAIL_AMT", 
                     "PROMO_SALES_IND_CD", "STAPLE_ITEM_FLG", "REGION_CD", "CUSTOMER_SK")
# Naming Columns Appropriately

counts_customer_sk <- sales211 %>%
    group_by(CUSTOMER_SK) %>% 
    summarise(n= n()) %>%
    arrange(n)


################################# PRODUCT ########################################################## 
#product <- product[,which(names(product) %nin% c("VISITS_PURCHASED"))]
# Removed VISITS_PURCHASED, since it is identical with BASKET_SIZE


product <- product[product$TOTAL_REVENUE < 15000,]
# Removed the outlier rows

ggpairs_product <- ggpairs(product[,which(names(product) %nin% c("ITEM_ID"))], 
                            upper = list(continious = ggally_points),
                            lower = list(continious = points),
                            title = "Products data Raw pairs")




scaled_ranges <- sapply(as.data.frame((scale(product[,c(2:5)]))), range)
# View min-max values for each column

product_scaled <- scale(product[,c(2:5)])
#scaled all the columns except for item_id

product_scaled$TOTAL_REVENUE <- 2 * product_scaled$TOTAL_REVENUE

set.seed(123)
# set seed before running non-deterministic algorithm


elbow_plot <- plot(withinSSrange(product_scaled,1,50,150))
# elbow plot for number of cluster selection

product_4_clusters <- kmeans(product_scaled, 4, 100)
# kmeans output for 4 clusters

product_5_clusters <- kmeans(product_scaled, 5, 100)
# kmeans output for 5 clusters

product_centers_4 <- unscale(product_4_clusters$centers, product_scaled)
# dataframe of centers for each cluster & column

product_centers_5 <- unscale(product_5_clusters$centers, product_scaled)
# dataframe of centers for each cluster & column

product_w_cluster_numbers_4 <- cbind(product, product_4_clusters$cluster)
# appended corresponding cluster to each product

product_w_cluster_numbers_5 <- cbind(product, product_5_clusters$cluster)
# appended corresponding cluster to each product



names(product_w_cluster_numbers_4)[6] <- "CLUSTER"
# renamed cluster column properly

names(product_w_cluster_numbers_5)[6] <- "CLUSTER"
# renamed cluster column properly

plot(product_w_cluster_numbers_4[,2:5], col = product_w_cluster_numbers_4$CLUSTER)
# plotting the final correlations highlighted by 4 clusters

plot(product_w_cluster_numbers_5[,2:5], col = product_w_cluster_numbers_5$CLUSTER)
# plotting the final correlations highlighted by 5 clusters










      

