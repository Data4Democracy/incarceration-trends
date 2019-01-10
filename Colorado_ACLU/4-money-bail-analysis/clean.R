

# Charlotte McClintock
# Colorado ACLU Project: Money Bail Analysis
# Cleaning Script for New Filings, New Offense Types

# ....................................................................................................

library(tidyverse)

# ....................................................................................................

# FELONY NEW FILINGS BY DISTRICT
felony.new.dist <- read_csv("tab6-felonybondposted-district-newfiling.csv")
# drop formatting rows, percent rows
felony.new.dist <- felony.new.dist[-c(1:2), c(1,3,5,7)]
# create variable names
names(felony.new.dist) <- c("district", "n2014", "n2015", "n2016")
# move bond names to a new column
felony.new.dist$bond <- with(felony.new.dist, ifelse(is.na(as.numeric(district)), district, NA))
# name for total new filings
felony.new.dist$bond <- with(felony.new.dist, ifelse(is.na(bond), "Total New Filings", bond))
# coerce to numeric to get NAs
felony.new.dist$district <- as.numeric(felony.new.dist$district)

# function from Stack Overflow to repeat district names where there are NA
repeat.before = function(x) {   # repeats the last non NA value. Keeps leading NA
  ind = which(!is.na(x))      # get positions of nonmissing values
  if(is.na(x[1]))             # if it begins with a missing, add the 
    ind = c(1,ind)        # first position to the indices
  rep(x[ind], times = diff(   # repeat the values at these indices
    c(ind, length(x) + 1) )) # diffing the indices + length yields how often 
}  
felony.new.dist$district <- repeat.before(felony.new.dist$district)

# gather years into long format
felony.new.dist <- gather(felony.new.dist, key = "year", value="n_newfiling", n2014:n2016)
# check how many times each district appears
arb <- felony.new.dist %>% group_by(district) %>% count()
# arrange, remove year totals
felony.new.dist <- arrange(felony.new.dist, district)
felony.new.dist <- filter(felony.new.dist, !bond=="Total")
# rename yes and no for reshape
felony.new.dist[c(seq(3, 458, 7)),2] <- "Money Bond - No"
felony.new.dist[c(seq(4, 459, 7)),2] <- "Money Bond - Yes"
felony.new.dist[c(seq(6, 461, 7)),2] <- "PR - No"
felony.new.dist[c(seq(7, 462, 7)),2] <- "PR - Yes"
# spread bond names to columns
felony.new.dist <- spread(felony.new.dist, key=bond, value=n_newfiling)
# rename variables for ease of analysis
names(felony.new.dist) <- c("district", "year", "moneybond", "moneybond_no", "moneybond_yes", 
                            "prbond", "prbond_no", "prbond_yes", "totalnewfiling")
# recode year variable
felony.new.dist <- mutate(felony.new.dist, 
                          year=as.factor(year),
                          year=fct_recode(year,
                                         "2014"="n2014", "2015"="n2015", "2016"="n2016"))

felony.new.dist$bondsettype <- "Felony"

# ....................................................................................................

# MISDEMEANOR NEW FILINGS BY DISTRICT
mis.new.dist <- read_csv("tab8-misdemeanorbondposted-district-newfiling.csv")
# drop formatting rows, percent rows
mis.new.dist <- mis.new.dist[-c(1:2), c(1,3,5,7)]
# create variable names
names(mis.new.dist) <- c("district", "n2014", "n2015", "n2016")
# move bond names to a new column
mis.new.dist$bond <- with(mis.new.dist, ifelse(is.na(as.numeric(district)), district, NA))
# name for total new filings
mis.new.dist$bond <- with(mis.new.dist, ifelse(is.na(bond), "Total New Filings", bond))
# coerce to numeric to get NAs
mis.new.dist$district <- as.numeric(mis.new.dist$district)

# function from Stack Overflow to repeat district names where there are NA
repeat.before = function(x) {   # repeats the last non NA value. Keeps leading NA
  ind = which(!is.na(x))      # get positions of nonmissing values
  if(is.na(x[1]))             # if it begins with a missing, add the 
    ind = c(1,ind)        # first position to the indices
  rep(x[ind], times = diff(   # repeat the values at these indices
    c(ind, length(x) + 1) )) # diffing the indices + length yields how often 
}  
mis.new.dist$district <- repeat.before(mis.new.dist$district)

# gather years into long format
mis.new.dist <- gather(mis.new.dist, key = "year", value="n_newfiling", n2014:n2016)
# check how many times each district appears
arb <- mis.new.dist %>% group_by(district) %>% count()
# arrange, remove year totals
mis.new.dist <- arrange(mis.new.dist, district)
mis.new.dist <- filter(mis.new.dist, !bond=="Total")
# rename yes and no for reshape
mis.new.dist[c(seq(3, 437, 7)),2] <- "Money Bond - No"
mis.new.dist[c(seq(4, 438, 7)),2] <- "Money Bond - Yes"
mis.new.dist[c(seq(6, 440, 7)),2] <- "PR - No"
mis.new.dist[c(seq(7, 441, 7)),2] <- "PR - Yes"
# spread bond names to columns
mis.new.dist <- spread(mis.new.dist, key=bond, value=n_newfiling)
# rename variables for ease of analysis
names(mis.new.dist) <- c("district", "year", "moneybond", "moneybond_no", "moneybond_yes", 
                            "prbond", "prbond_no", "prbond_yes", "totalnewfiling")
# recode year variable
mis.new.dist <- mutate(mis.new.dist, 
                          year=as.factor(year),
                          year=fct_recode(year,
                                          "2014"="n2014", "2015"="n2015", "2016"="n2016"))
mis.new.dist$bondsettype <- "Misdemeanor"

# ....................................................................................................

# join misdemeanor and felony new filings data sets
newfilings.dist <- full_join(felony.new.dist, mis.new.dist, by=c(names(felony.new.dist)))
newfilings.dist <- select(newfilings.dist, bondsettype, everything())
write.csv(newfilings.dist, "newfilings-bydistrict&bondtype.csv")

# ....................................................................................................

# FELONY NEW FILINGS BY COUNTY
felony.new.county <- read_csv("tab7-felonybondposted-county-newfiling.csv")
# drop formatting rows, percent rows
felony.new.county <- felony.new.county[-c(1:2), c(1,3,5,7)]
# create variable names
names(felony.new.county) <- c("county", "n2014", "n2015", "n2016")
# move bond names to a new column
felony.new.county$bond <- with(felony.new.county, ifelse(county=="Cash/Surety/Property"|
                                                           county=="Yes"|county=="No"|
                                                           county=="Personal Recognizance", 
                                                         county, NA))
# name for total new filings
felony.new.county$bond <- with(felony.new.county, ifelse(is.na(bond), "Total New Filings", bond))
# get NAs for non-county names
felony.new.county$county <- with(felony.new.county, ifelse(county=="Cash/Surety/Property"|
                                     county=="Yes"|county=="No"|
                                     county=="Personal Recognizance", NA, county))

# function from Stack Overflow to repeat county names where there are NA
repeat.before = function(x) {   # repeats the last non NA value. Keeps leading NA
  ind = which(!is.na(x))      # get positions of nonmissing values
  if(is.na(x[1]))             # if it begins with a missing, add the 
    ind = c(1,ind)        # first position to the indices
  rep(x[ind], times = diff(   # repeat the values at these indices
    c(ind, length(x) + 1) )) # diffing the indices + length yields how often 
}  
felony.new.county$county <- repeat.before(felony.new.county$county)

# gather years into long format
felony.new.county <- gather(felony.new.county, key = "year", value="n_newfiling", n2014:n2016)

# remove year totals
felony.new.county <- filter(felony.new.county, !county=="Total")

# check how many times each county appears & arrange by that number to use numerical index replacement
arb <- felony.new.county %>% group_by(county) %>% count()
felony.new.county <- left_join(felony.new.county, arb, by="county")
felony.new.county <- arrange(felony.new.county, -n, county)

# rename yes and no for reshape - counties with 21 observations
felony.new.county[c(seq(3, 1235, 7)),2] <- "Money Bond - No"
felony.new.county[c(seq(4, 1236, 7)),2] <- "Money Bond - Yes"
felony.new.county[c(seq(6, 1238, 7)),2] <- "PR - No"
felony.new.county[c(seq(7, 1239, 7)),2] <- "PR - Yes"

# two counties which do not have "yes" for money bond to separate from 
# three other counties which do not have yes for PR
felony.new.county$n <- with(felony.new.county, ifelse(county=="Hinsdale"|county=="Mineral", 17, n))
felony.new.county <- arrange(felony.new.county, -n, county)

# rename yes and no for reshape - counties with 18 observations (yes for money bond)
felony.new.county[c(seq(1242, 1290, 6)),2] <- "Money Bond - No"
felony.new.county[c(seq(1243, 1291, 6)),2] <- "Money Bond - Yes"
felony.new.county[c(seq(1245, 1293, 6)),2] <- "PR - No"

arb <- felony.new.county %>% group_by(county, bond) %>% count()

# rename yes and no for reshape - counties with 18 observations (yes for PR bond)
felony.new.county[c(seq(1296, 1326, 6)),2] <- "Money Bond - No"
felony.new.county[c(seq(1298, 1328, 6)),2] <- "PR - No"
felony.new.county[c(seq(1299, 1329, 6)),2] <- "PR - Yes"

# spread bond names to columns
felony.new.county <- spread(felony.new.county, key=bond, value=n_newfiling) %>% select(-n)
# rename variables for ease of analysis
names(felony.new.county) <- c("county", "year", "moneybond", "moneybond_no", "moneybond_yes", 
                            "prbond", "prbond_no", "prbond_yes", "totalnewfiling")
# recode year variable
felony.new.county <- mutate(felony.new.county, 
                          year=as.factor(year),
                          year=fct_recode(year,
                                          "2014"="n2014", "2015"="n2015", "2016"="n2016"))

felony.new.county$bondsettype <- "Felony"


# ....................................................................................................

# MISDEMEANOR NEW FILINGS BY COUNTY
mis.new.county <- read_csv("tab9-misdemeanorbondposted-county-newfiling.csv")
# drop formatting rows, percent rows
mis.new.county <- mis.new.county[-c(1), c(1,3,5,7)]
# create variable names
names(mis.new.county) <- c("county", "n2014", "n2015", "n2016")
# move bond names to a new column
mis.new.county$bond <- with(mis.new.county, ifelse(county=="Cash/Surety/Property"|
                                                           county=="Yes"|county=="No"|
                                                           county=="Personal Recognizance", 
                                                         county, NA))
# name for total new filings
mis.new.county$bond <- with(mis.new.county, ifelse(is.na(bond), "Total New Filings", bond))
# get NAs for non-county names
mis.new.county$county <- with(mis.new.county, ifelse(county=="Cash/Surety/Property"|
                                                             county=="Yes"|county=="No"|
                                                             county=="Personal Recognizance", NA, county))

# function from Stack Overflow to repeat county names where there are NA
repeat.before = function(x) {   # repeats the last non NA value. Keeps leading NA
  ind = which(!is.na(x))      # get positions of nonmissing values
  if(is.na(x[1]))             # if it begins with a missing, add the 
    ind = c(1,ind)        # first position to the indices
  rep(x[ind], times = diff(   # repeat the values at these indices
    c(ind, length(x) + 1) )) # diffing the indices + length yields how often 
}  
mis.new.county$county <- repeat.before(mis.new.county$county)

# gather years into long format
mis.new.county <- gather(mis.new.county, key = "year", value="n_newfiling", n2014:n2016)

# remove year totals
mis.new.county <- filter(mis.new.county, !county=="Total")

# check how many times each county appears & arrange by that number to use numerical index replacement
arb <- mis.new.county %>% group_by(county) %>% count()
mis.new.county <- left_join(mis.new.county, arb, by="county")
mis.new.county <- arrange(mis.new.county, -n, county)

# rename yes and no for reshape - counties with 21 observations
mis.new.county[c(seq(3, 1235, 7)),2] <- "Money Bond - No"
mis.new.county[c(seq(4, 1236, 7)),2] <- "Money Bond - Yes"
mis.new.county[c(seq(6, 1238, 7)),2] <- "PR - No"
mis.new.county[c(seq(7, 1239, 7)),2] <- "PR - Yes"

# rename yes and no for reshape - counties with 18 observations (yes for money bond)
mis.new.county[c(seq(1242, 1290, 6)),2] <- "Money Bond - No"
mis.new.county[c(seq(1243, 1291, 6)),2] <- "Money Bond - Yes"
mis.new.county[c(seq(1245, 1293, 6)),2] <- "PR - No"

# rename yes and no for reshape - counties with 18 observations (yes for PR bond)
mis.new.county[c(seq(1296, 1302, 3)),2] <- "Money Bond - No"

# spread bond names to columns
mis.new.county <- spread(mis.new.county, key=bond, value=n_newfiling) %>% select(-n)
# rename variables for ease of analysis
names(mis.new.county) <- c("county", "year", "moneybond", "moneybond_no", "moneybond_yes", 
                              "prbond", "prbond_no", "prbond_yes", "totalnewfiling")
# recode year variable
mis.new.county <- mutate(mis.new.county, 
                            year=as.factor(year),
                            year=fct_recode(year,
                                            "2014"="n2014", "2015"="n2015", "2016"="n2016"))

mis.new.county$bondsettype <- "Misdemeanor"
# ....................................................................................................

# join misdemeanor and felony new filings data sets
newfilings.county <- full_join(felony.new.county, mis.new.county, by=c(names(felony.new.county)))
newfilings.county <- select(newfilings.county, bondsettype, everything())
write.csv(newfilings.county, "newfilings-bycounty&bondtype.csv")

# ....................................................................................................

# NEW FILING MOST SERIOUS OFFENSE TYPE

# FELONY
# read in the data
felony.offtype <- read_csv("tab10-felonybondposted-offensetype.csv")[-1,]
# rename variables
names(felony.offtype) <- c("mostseriousoffense", "perc_preHB1236", "n_preHB1236", 
                           "perc_postHB1236", "n_postHB1236")
# add felony classification
felony.offtype$firstofftype <- "Felony"

# MISDEMEANOR
# read in the data
mis.offtype <- read_csv("tab11-misdemeanorbondposted-offensetype.csv")[-1,]
# rename variables
names(mis.offtype) <- c("mostseriousoffense", "perc_preHB1236", "n_preHB1236", 
                           "perc_postHB1236", "n_postHB1236")
# add misdemeanor classification
mis.offtype$firstofftype <- "Misdemeanor"

# join felony and misdemeanor
new.offtype <- full_join(felony.offtype, mis.offtype, by=c("mostseriousoffense", "perc_preHB1236", 
                                                           "n_preHB1236", "perc_postHB1236", 
                                                           "n_postHB1236", "firstofftype"))
# reorder variables
new.offtype <- select(new.offtype, firstofftype, everything())

# write as a csv
write.csv(new.offtype, "newfilings-bybond&offensetype.csv")

# ....................................................................................................

bondset <- read_csv("county_bond_data.csv")
newfiling <- read_csv("newfilings-bycounty&bondtype.csv") %>% select(-X1)

names(bondset) <- c("county", "year", "money_bond_freq", "pr_bond_freq", 
                    "total_bond_freq", "off_type")

bondset <- mutate(bondset, 
                  off_type=as.factor(off_type), 
                  off_type=fct_recode(off_type, 
                                      "Felony"="felonybondtype",
                                      "Misdemeanor"="misdemeanorbondtype"),
                  off_type=as.character(off_type))

names(newfiling) <- c("off_type", "county", "year", "money_posted", 
                      "money_bond_new_no", "money_new_yes", "pr_posted", 
                      "pr_new_no", "pr_new_yes", "total_new")

county_bonds <- left_join(bondset, newfiling, by=c("county", "year", "off_type"))

write.csv(county_bonds, "complete-county-bond.csv")



