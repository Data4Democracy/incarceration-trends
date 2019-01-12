
# Charlotte McClintock
# Colorado ACLU Project: Money Bail Analysis
# Analysis Script

# ....................................................................................................

library(tidyverse)
library(margins)

# ....................................................................................................

# read in the data
bondset <- read_csv("county_bond_data.csv")
bond.new <- read_csv("newfilings-bycounty&bondtype.csv") %>% select(-X1)
bond.new.off <- read_csv("newfilings-bybond&offensetype.csv") %>% select(-X1)

# ....................................................................................................

<<<<<<< HEAD
# COUNTY BOND SET BREAKDOWN
=======
# COUNTY BOND SET BREAKDOWNS
>>>>>>> e6b1bd02ad0863cfb7259d01c877151e088098c5

# rename bond variables
names(bondset) <- c("county", "year", "money_bond", "pr_bond", "total_bond", "crime_type")
# round percents, recode crime types
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

# how did bondset percentages change from 2014-2016 (if at all)?
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

# where did HB13.1236 have the most significant effect?
head(arrange(select(filter(bond.new.off, firstofftype=="Felony"), firstofftype, 
                    mostseriousoffense, HB1236_impact),  -abs(HB1236_impact)), 16)
head(arrange(select(filter(bond.new.off, firstofftype=="Misdemeanor"), firstofftype, 
                    mostseriousoffense, HB1236_impact),  -abs(HB1236_impact)), 16)

# median impact of HB13.1236, split by crime type
with(bond.new.off, median(abs(HB1236_impact)))
with(filter(bond.new.off, firstofftype=="Felony"), median(abs(HB1236_impact)))
with(filter(bond.new.off, firstofftype=="Misdemeanor"), median(abs(HB1236_impact)))
# mean impact of HB13.1236, split by crime type
with(bond.new.off, mean(abs(HB1236_impact)))
with(filter(bond.new.off, firstofftype=="Felony"), mean(abs(HB1236_impact)))
with(filter(bond.new.off, firstofftype=="Misdemeanor"), mean(abs(HB1236_impact)))

# create df to compare most serious offense by first offense class
mis <- filter(bond.new.off, firstofftype=="Misdemeanor") %>% select(mostseriousoffense, perc_postHB1236)
names(mis) <- c("mostseriousoffense", "mis_perc")
felony <- filter(bond.new.off, firstofftype=="Felony") %>% select(mostseriousoffense, perc_postHB1236) 
names(felony) <- c("mostseriousoffense", "felony_perc")
felony.mis.diff <- left_join(mis, felony, by="mostseriousoffense")
felony.mis.diff <- mutate(felony.mis.diff, 
                          diff=felony_perc-mis_perc, 
                          morelikely=ifelse(diff<0, "Misdemeanor More Likely", "Felony More Likely"))

# ....................................................................................................

# read in the complete county data
county <- read_csv("complete-county-bond.csv") %>% select(-X1)

# create new variables
county <- mutate(county,
                 money_new_perc = money_new_yes/money_posted, 
                 pr_new_perc = pr_new_yes/pr_posted, 
                 diff_new=money_new_perc-pr_new_perc,
                 diff_dir=ifelse(diff_new>0, "More New Filings for Money Bonds", 
                                 "More New Filings for PR Bonds"),
                 money_posted_diff=money_posted-money_bond_freq,
                 pr_posted_diff=pr_posted-pr_bond_freq, 
                 money_posted_perc=money_posted/money_bond_freq,
                 money_set_perc=money_bond_freq/total_bond_freq)

# how are the percent of offenders released on money bond who pick up new charges and the 
# percent of offenders released on PR bond who pick up new charges related? 
cor(county$money_new_perc, county$pr_new_perc, use="pairwise.complete.obs") # r^2=0.48
ggplot(county, aes(x=money_new_perc, y=pr_new_perc)) + geom_point() + 
  geom_smooth(method="lm") + ylim(0, 0.6) # relatively strong positive correlation
# is this similar for misdemeanors and felonies?
ggplot(county, aes(x=money_new_perc, y=pr_new_perc)) + geom_point() + 
  geom_smooth(method="lm") + ylim(0, 0.6) + facet_wrap(~off_type)

# how are the percent of offenders released on money bond who pick up new charges and the 
# and the percent of offenders who post money bond related?
cor(county$money_new_perc, county$money_posted_perc, use="pairwise.complete.obs") #r^2=0.1
ggplot(county, aes(x=money_new_perc, y=money_posted_perc)) + geom_point() + 
  geom_smooth(method="lm") + ylim(0, 1) # no strong relationship
# is this similar for misdemeanors and felonies?
ggplot(county, aes(x=money_new_perc, y=money_posted_perc)) + geom_point() + 
  geom_smooth(method="lm") + ylim(0, 1) + facet_wrap(~off_type)
# slightly positive correlation for felonies, slightly negative for misdemeanors

# what is the mean absolute difference between money bonds and pr bonds in 
# frequency of picking up new charges while out on bond?
county %>% group_by(year) %>% summarize(diff_mean=mean(abs(diff_new), na.rm=T))

# visualization of money bond
ggplot(filter(county, year==2016&!diff_new==0), 
       aes(x=reorder(county, diff_new), y=diff_new, fill=diff_dir)) + 
  stat_summary(fun.y="sum", geom="bar", position="dodge") + coord_flip() + facet_wrap(~off_type)

# ....................................................................................................

# read in crime rate data
crime <- read_csv("crime-rate-bycounty.csv")
names(crime) <- c("county", "offense", "year", "n")
# drop "County" from county names for merge 
crime <- separate(crime, county, into = "county", extra="drop", sep=" County")
# spread offense classes
crime <- spread(crime, key = "offense", value="n")
names(crime) <- c("county","year", "crime_persons", "crime_property", "crime_society", "missing") 
# not sure what missing column is here

pop <- read_csv("county-populations.csv", col_names = F)
pop <- t(pop)
pop <- as.data.frame(pop)
names(pop) <- c("county", "population", "pop_density")
pop <- pop[-c(1),]
pop <- separate(pop, county, into = "county", extra="drop", sep=" County")

crime <- left_join(crime, pop, by=c("county"))

crime <- mutate(crime, 
                population=as.character(population),
                pop_density=as.character(pop_density),
                population=as.numeric(gsub(",", "", population)),
                pop_density=as.numeric(gsub(",", "", pop_density)),
                crime_persons_rate = crime_persons/population,
                crime_property_rate = crime_property/population,
                crime_society_rate = crime_society/population)

county <- left_join(county, crime, by=c("county", "year"))

ggplot(filter(county, year==2016), aes(x=money_new_perc, y=crime_persons_rate)) + geom_point() + 
  geom_smooth(method="lm") + facet_wrap(~off_type)

ggplot(filter(county, year==2016), aes(x=money_new_perc, y=crime_property_rate)) + geom_point() + 
  geom_smooth(method="lm") + facet_wrap(~off_type)

ggplot(filter(county, year==2016), aes(x=money_new_perc, y=crime_society_rate)) + geom_point() + 
  geom_smooth(method="lm")  + facet_wrap(~off_type)

ggplot(filter(county, year==2016), aes(x=pr_new_perc, y=crime_persons_rate)) + geom_point() + 
  geom_smooth(method="lm") + facet_wrap(~off_type)

ggplot(filter(county, year==2016), aes(x=pr_new_perc, y=crime_property_rate)) + geom_point() + 
  geom_smooth(method="lm") + facet_wrap(~off_type) 

ggplot(filter(county, year==2016), aes(x=pr_new_perc, y=crime_society_rate)) + geom_point() + 
  geom_smooth(method="lm")  + facet_wrap(~off_type)

ggplot(filter(county, year==2016), aes(y=money_new_perc, x=pop_density)) + geom_point() + 
  geom_smooth(method="lm")  + facet_wrap(~off_type)

# ....................................................................................................


save.image("moneybail.Rdata")
