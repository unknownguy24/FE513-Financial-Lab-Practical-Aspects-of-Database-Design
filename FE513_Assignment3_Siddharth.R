library(DBI)
library(RODBC)
library(odbc)
con <- dbConnect(odbc::odbc(),"PostgreSQL30")

csv_file_path <- "C:/Users/siddh/Downloads/banks_total_siddharth.csv"
banks_total <- read.csv(csv_file_path)
new_table_name <- "banks_total_new"

dbWriteTable(con, new_table_name, banks_total, overwrite = TRUE, row.names = FALSE)

banks_total_data <- dbReadTable(con, new_table_name)
num_rows <- nrow(banks_total_data)
print(num_rows)
