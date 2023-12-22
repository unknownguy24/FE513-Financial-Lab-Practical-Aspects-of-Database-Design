library(odbc)
con <- dbConnect(odbc::odbc(), "PostgreSQL30")

dbListTables(con)

library(DBI)
bank_data_siddharth <- dbReadTable(con, "bank_data")

library(dplyr)

bank_data_siddharth <- bank_data_siddharth %>%
  arrange(id, date) %>%
  group_by(id) %>%
  mutate(growth_rate_siddharth = (asset - lag(asset)) / lag(asset))

# Remove the first observation for each bank as it will have an NA for the growth rate
bank_data_siddharth <- bank_data_siddharth %>%
  filter(!is.na(growth_rate_siddharth))

head(bank_data_siddharth)

dbWriteTable(con, 'bank_growth_rates_siddharth', bank_data_siddharth, append = TRUE, row.names = FALSE)
dbListTables(con)
