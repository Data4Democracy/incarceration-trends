
# Charlotte McClintock
# Colorado ACLU Project: Jail Population Analysis
# Data Cleaning Script

# ....................................................................................................

library(tidyverse)

# ....................................................................................................

# read in the data
violent <- read_csv("colorado_violentcrime_2008-2017.csv")
property <- read_csv("colorado_propertycrime_2008-2017.csv")
drug <- read_csv("colorado_drugcrime_2008-2017.csv")

# transform data to better format for merge with violent crime data
property <- gather(property, key="year", value="total", `2008`:`2017`)
# rename variable for merge
property <- rename(property, "offense"="offense_type")
# coerce variable to integer class for merge
property$year <- as.integer(property$year)

# drop empty rows
drug <- drug[1:10,]
drug <- gather(drug, key="offense", value=total, dui:drugequipment_violations)
drug <- mutate(drug, 
               offense=as.factor(offense),
               offense=fct_recode(offense,
               "DUI"="dui",
               "Drug/Narcotic Violations"="drug_violations",
               "Drug Equipment Violations"="drugequipment_violations"))

# add crime class variable
violent$class <- "Violent"
property$class <- "Property"
drug$class <- "Drug/DUI"

# join data together
crime <- full_join(violent, property, by=c("year","offense", "total", "class"))
crime <- full_join(crime, drug, by=c("year","offense", "total","class"))

# reorder variables
crime <- select(year, class, offense, everything())

# get rid of violent crime summary rows
crime <- filter(crime, !offense=="Violent Crime")

write_csv(crime, "colorado_crime_stats.csv")

# ....................................................................................................

pop <- read_csv("colorado_population_2008-2017.csv") %>% select(-X1)

crime %>% group_by(year, class) %>% summarize(class_total=sum(total)) %>% left_join(pop, by="year") %>% 
  ggplot(aes(x=year, y=class_total/pop_estimate, colour=class)) + geom_point() + geom_line()
