
# Charlotte McClintock
# Colorado ACLU Project: Money Bail Analysis
# Analysis Script

# ....................................................................................................

library(tidyverse)

# ....................................................................................................

bondset <- read_csv("county_bond_data.csv")
bond.new <- read_csv("newfilings-bycounty&bondtype.csv") %>% select(-X1)
bond.new.off <- read_csv("newfilings-bybond&offensetype.csv") %>% select(-X1)

# ....................................................................................................

# COUNTY BOND SET BREAKDOWNs

names(bondset) <- c("county", "year", "money_bond", "pr_bond", "total_bond", "crime_type")
bondset <- mutate(bondset, 
                  money_perc = round(money_bond/total_bond, 2),
                  pr_perc = round(pr_bond/total_bond,2),
                  crime_type=as.factor(crime_type),
                  crime_type=fct_recode(crime_type,
                                        "Misdemeanor Offense"="misdemeanorbondtype",
                                        "Felony Offense"="felonybondtype"))

# which counties are using money bonds most often by crime type in 2016?
head(arrange(filter(bondset, total_bond>50), -year, crime_type, -money_perc), 10)
head(arrange(filter(bondset, total_bond>50), -year, desc(crime_type), -money_perc), 10)


ggplot(bondset, aes(year, money_perc)) + geom_point() + 
  facet_wrap(~crime_type) + geom_smooth(method="lm") + geom_point() 

year.change <- gather(filter(bondset, total_bond>50), key="bond_type", value="n_bonds", money_bond:total_bond, money_perc:pr_perc)
year.change <- spread(year.change, key=year, value=n_bonds)
year.change$diff <- with(year.change, `2016`-`2014`)
year.change <- filter(year.change, bond_type=="money_perc"|bond_type=="pr_perc")
year.change <- mutate(year.change, 
                      bond_type=fct_recode(bond_type,
                                           "Money Bond"="money_perc",
                                           "PR Bond"="pr_perc"))
head(arrange(filter(year.change), crime_type, bond_type, -diff), 10)
head(arrange(filter(year.change), desc(crime_type), bond_type, -diff), 10)

total <- unique(select(bondset, county, year, crime_type, total_bond))

# ....................................................................................................

# COUNTY NEW FILING OFFENSE TYPE

bond.new.off <- separate(bond.new.off, perc_preHB1236, into="perc_preHB1236", sep="%", extra = "drop" )
bond.new.off <- separate(bond.new.off, perc_postHB1236, into="perc_postHB1236", sep="%", extra = "drop" )

bond.new.off <- mutate(bond.new.off,
                       perc_postHB1236=as.numeric(perc_postHB1236),
                       perc_preHB1236=as.numeric(perc_preHB1236),
                       firstofftype=as.factor(firstofftype),
                       HB1236_impact=perc_postHB1236-perc_preHB1236)

head(arrange(select(bond.new.off, firstofftype, mostseriousoffense, HB1236_impact), 
             -abs(HB1236_impact)), 16)

# ....................................................................................................

save.image("moneybail.Rdata")
