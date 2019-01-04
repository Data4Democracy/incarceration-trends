
library(tidyverse)

target_dir <- 'repweissman-data/'

# # # county data

county_dfs <- 
  c('tab4-misdemeanorbondtype-county.csv',
    'tab2-felonybondtype-county.csv')
county_df <- data.frame()

for (i in county_dfs) {
  mb_df <- read_csv(str_c(target_dir, i))
  
  county_names <- sort(unlist(rep(unique(mb_df[,1]), 3)))
  
  mb_df$county <- 
    county_names[which(!(county_names %in% c('Cash/Surety/Property', 'Personal Recognizance', 'Total')))]
  
  mb_df$bond_type <- unlist(lapply(mb_df[,1], function(x) {
    ifelse(x %in% mb_df$county, "total", x)
  }))
  
  mb_df <- mb_df[,2:6] %>%
    gather("year", "amount", 1:3)
  
  mb_df <- mb_df %>%
    spread(bond_type, amount)
  
  mb_df$bondtype <- unlist(str_split(i, "-"))[2]
  
  colnames(mb_df) <- c('county', 'year',
                       'cash_surety_property_bond_frequency',
                       'personal_recognizance_bond_frequency',
                       'total_bond_frequency', 'bond_type')
  
  county_df <- rbind.data.frame(county_df, mb_df)
  
}

write_csv(county_df, "county_bond_data.csv")

# # # district data

district_dfs <- 
  c('tab3-misdemeanorbondtype-district.csv',
    'tab1-felonybondtype-district.csv')
district_df <- data.frame()

for (i in district_dfs) {
  mb_df <- read_csv(str_c(target_dir, i))
  mb_df$district <- sort(c(1:22, 1:22, 1:22))

  mb_df$bond_type <- unlist(lapply(mb_df[,1], function(x) {
    ifelse(is.finite(as.numeric(x)), "total", x)
  }))

  mb_df <- mb_df[,2:6] %>%
    gather("year", "amount", 1:3)

  mb_df <- mb_df %>%
    spread(bond_type, amount)

  mb_df$bondtype <- unlist(str_split(i, "-"))[2]
  
  colnames(mb_df) <- c('district', 'year',
                       'cash_surety_property_bond_frequency',
                       'personal_recognizance_bond_frequency',
                       'total_bond_frequency', 'bond_type')

  district_df <- rbind.data.frame(district_df, mb_df)
  
  }

write_csv(district_df, "district_bond_data.csv")
