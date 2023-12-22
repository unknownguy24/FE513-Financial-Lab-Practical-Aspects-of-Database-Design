get_stock_analysis <- function(ticker, start_date, end_date, window_size) {
  #Part 1: Download daily stock data for the given ticker and time period
  stock_data <- getSymbols(ticker, src = "yahoo", from = start_date, to = end_date, auto.assign = FALSE)
  
  #Part 2: Extract and focus on the adjusted close prices from the downloaded data
  adj_close <- Cl(stock_data)
  
  #Part 3 & Part 4: Initialize a dataframe to store the rolling window calculation results
  rolling_stats <- data.frame(Window_Index = integer(0), Mean_Price = numeric(0), Price_Volatility = numeric(0))
  
  #Perform rolling window calculations across the stock data
  for (i in 1:(nrow(adj_close) - window_size + 1)) {
    window_data <- adj_close[i:(i + window_size - 1)]
    window_mean <- round(mean(window_data), 2) #Mean rounded to 2 decimal places
    window_std <- round(sd(window_data), 2)    #Standard deviation rounded to 2 decimal places
    
    #Add the calculated statistics to the rolling_stats dataframe
    rolling_stats <- rbind(rolling_stats, data.frame(Window_Index = i, Mean_Price = window_mean, Price_Volatility = window_std))
  }
  
  #Part 5: Plotting the statistical results as a scatter plot
  scatter_plot <- ggplot(data = rolling_stats, aes(x = Window_Index)) +
    geom_point(aes(y = Mean_Price, color = "Average Price")) +
    geom_point(aes(y = Price_Volatility, color = "Volatility")) +
    labs(title = paste("Stock Analysis -", ticker),
         x = "Rolling Window Index",
         y = "Statistical Measures") +
    scale_color_manual(values = c("Average Price" = "green", "Volatility" = "orange")) +
    theme_minimal() +
    guides(color = guide_legend(title = "Metrics"))
  
  #Explicitly print the scatter plot
  print(scatter_plot)
  
  #Part 6: Return the compiled dataframe with statistical data
  return(rolling_stats)
}

#Example usage to test the function with specific parameters
result <- get_stock_analysis("ADBE", "2021-01-01", "2022-01-01", 20)
#Displaying the top rows of the resulting dataframe
head(result)
