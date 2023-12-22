#PART 1 
set.seed(123)
#Creating two vectors with 10 rn 

vector_1 <- runif(10, min = 0, max = 1)  
vector_2 <- runif(10, min = 0, max = 1)  

#Appending the second vector to the first one

new_vector <- c(vector_1, vector_2)

print("Appended Vector:")
print(new_vector)

#Calculating the mean of the new vector

mean_ <- mean(new_vector)

#We will print 'True' for values greater than the mean, 'False' if it is lesser than the mean

output <- ifelse(new_vector > mean_, 'True', 'False')

#Output

print("Result:")
print(output)

######################################################

#PART 2

set.seed(456)

#Creating a vector with 100 random numbers

vector_ <- runif(100, min = 0, max = 1)

#Converting the vector into a 10 by 10 matrix

M <- matrix(vector_, nrow = 10, ncol = 10)

#Finding the transposed matrix

M_t <- t(M)

#Printing elements as asked in the question

element_2r_1c <- M_t[2, 1]
print("Element in the second row and first column of Mt:")
print(element_2r_1c)

#Calculating the inner product to create matrix N

#Intitializing N first as an empty matrix
N <- matrix(0, nrow = 10, ncol = 10)  

#Calculating
for (i in 1:10) {
  for (j in 1:10) {
    N[i, j] <- sum(M_t[i,] * M[,j])  
  }
}

#Calculating the inner product using the %*% operator

N_2 <- M_t %*% M

# Comparing both the results by if-else

if (identical(N, N_2)) {
  cat("Same results for N.\n")
} else {
  cat("Different results for N.\n")
}

##################################################################

#PART 3

#Directory
setwd("C:/Users/siddh/Downloads/try")

#CSV file
data <- read.csv("stock_data-1.csv")

#Deleting the columns containing NA
data <- data[ , -c(match("CRM", names(data)), match("DOW", names(data)), match("GS", names(data)), match("V", names(data)))]

head(data)
cols = ncol(data)
#Daily log return for each stock
log_data = data

log_data[1,2:cols] = 0
for(i in 2:nrow(data)){
  log_data[i, 2:cols] = log(data[i,2:cols])-log(data[i-1,2:cols])
}

head(log_data)

#Mean
mean_log_return <- apply(log_data[2:nrow(log_data), 2:cols], 2, mean)

#Standard deviation
sd_log_return <- apply(log_data[2:nrow(log_data), 2:cols], 2, sd)

#Dataframe for both
mean_sd_df <- data.frame(mean_log_return, sd_log_return)

head(mean_sd_df)

# Creating a subset of the first three stocks daily prices
three_stock_data <- data[, c("X", "AAPL", "AMGN", "AXP")]

library(reshape2)

melted_stock_data <- melt(three_stock_data, id.vars = "X", variable.name = "Stock", value.name = "Price")
melted_stock_data$X <- as.Date(melted_stock_data$X)

# Creating the first sub-plot
plot1 <- ggplot(data = melted_stock_data, aes(x = X, y = Price, color = Stock)) +
  geom_line() +
  labs(title = "Daily Prices of First Three Stocks",
       x = "Date",
       y = "Stock Price") +
  theme_minimal()

# Creating the second sub-plot
plot2 <- ggplot(data = mean_sd_df, aes(x = rownames(mean_sd_df), y = mean_log_return)) +
  geom_point(aes(size = sd_log_return), color = "blue") +
  labs(title = "Statistical Results for Stocks",
       x = "Stocks",
       y = "Mean Log Return",
       size = "Standard Deviation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Combining the two sub-plots
library(gridExtra)
output_plot <- grid.arrange(plot1, plot2, ncol = 1, heights = c(2, 1))

print(output_plot)


######################################################################

#QUESTION 2

#install.packages("quantmod")
library(quantmod)

#Getting the data
start <- "2021-01-01"
end <- "2021-12-31"
getSymbols("AMZN", from = start, to = end)

#Calculating weekly log returns
weekly_log_returns <- periodReturn(AMZN, period = "weekly", col = "Adjusted", leading = FALSE)

head(weekly_log_returns)

adjusted_col_name <- colnames(weekly_log_returns)[1]

#Mean
mean_return <- mean(weekly_log_returns[, adjusted_col_name])

#Median
median_return <- median(weekly_log_returns[, adjusted_col_name])

#Standard deviation
std_return <- sd(weekly_log_returns[, adjusted_col_name])

# Step 4: Plot the distribution of weekly log returns (histogram)
hist(weekly_log_returns[, adjusted_col_name], breaks = 30, main = "Distribution of Weekly Log Returns",
     xlab = "Weekly Log Returns", ylab = "Frequency", col = "lightgray")

# Step 5: Count observations with log returns between 0.01 and 0.015
count_ <- sum(weekly_log_returns[, adjusted_col_name] >= 0.01 & weekly_log_returns[, adjusted_col_name] <= 0.015)

# Save the data to a CSV file
write.csv(weekly_log_returns, file = "out.csv")

# Print outputs
cat("Mean Log Return:", mean_return, "\n")

cat("Median Log Return:", median_return, "\n")

cat("Standard Deviation of Log Returns:", std_return, "\n")

cat("Number of Observations between 0.01 and 0.015:", count_, "\n")



