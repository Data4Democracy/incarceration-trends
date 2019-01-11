###############################################################
# Incarceration Trends for Colorado ACLU Exploratory Analysis # 


# Intro  #
##########

# This script is meant to serve as an exploratory analysis for the Data For Democracy incarceration trends project
# in conjunction with the Colorado ACLU. 


# Background #
##############

# Anecdotally, the Jail Population is CO is rising. Some claim it is driven by a rise in crime. 
# However,the trend from the past 40 years seems to evidence the opposite. We would like to look at what has occured between
# 2008-2017 to see which claims hold validity in the current environment. 

# ........................................................

library(tidyverse)
library(xlsx)

# .........................................................


# Data #
########
crime <- read_csv("colorado_crime_stats.csv") # This file details the type of crime documented in Colorado by year and was generated from the script clean.R
population <- read_csv("colorado_population_2008-2017.csv")[,-1] # File details the ACS Population estimates for colorado population 2008-2017
incarceration <- read.xlsx("colorado-incarceration-hist.xlsx",1, header = FALSE)[,-3] # Details Jail population by year from the Vera incarceration-trends data set
co_vera_data <-  read_csv("Colorado-Incarceration-Data.csv") # Details all Vera incarceration-trends data set for state of Colorado
census_join <- read_csv("vera_census_join.csv")

# Analysis Steps #
##################
# 1) Look at various rates of crime as a proportion of the population
crime.agg <- crime %>% group_by(year, class) %>% summarise(total = sum(total)) # This aggregates the number of crimes by class by year 

crime.per <- crime.agg %>% 
  inner_join(population, by = "year") %>% 
  mutate(crime.percent = total/pop_estimate *100 ) %>%
  select(year, class, crime.percent)

crime.rate.vis <- ggplot(crime.per, aes(x= year, y = crime.percent, color = class)) +
  geom_line() + 
  geom_point()+
  ggtitle('Crime Rate by Type Over Time') +
  theme(
    plot.title = element_text(size=15, face="bold", family = "serif", hjust = 0.5 ),
    axis.title.x = element_text(vjust=-0.5, size = 15, family ="serif"),
    axis.title.y = element_text(vjust=0.75,family ="serif", size = 15),
    axis.text.x=element_text(angle=50, size=10, vjust=0.5, family ="serif"),
    axis.text.y=element_text(angle= 0, size=10, vjust=.05,family ="serif"),
    panel.background = element_rect(fill = 'white'),
    panel.grid.major = element_line(colour = "grey", size = .3, linetype = "dashed" ),
    panel.grid.minor = element_line(colour = "white", size = .5),
    legend.text = element_text(family = "serif"), 
    legend.title = element_text(family = "serif", face = "bold"),
    legend.position = c(0.9, 0.50))+ 
  ylim(0, 4.0) +
  scale_x_continuous(breaks = seq(2008, 2017, 1), limits = c(2008,2017)) +
  labs(x="Year", y="Crime Rate (% of State Population)" , color = "Type of Crime")
crime.rate.vis

# Look at total CO jail population for each year
# do this using the vera data
View(co_vera_data)

co_jail_pop_by_year <- co_vera_data %>% 
  select(year, total_jail_pop, female_jail_pop, male_jail_pop, black_jail_pop, white_jail_pop, total_pop_15to64, total_pop) %>%
  group_by(year)%>%
  summarise_all(funs(sum(., na.rm = TRUE)))
View(co_jail_pop_by_year)

# Look at the incarceration vile
View(incarceration)
names(incarceration) <- c("year", "jail_pop" )

incarc.pop <- incarceration %>% 
  left_join(select(co_jail_pop_by_year, year, total_pop_15to64, total_pop), by = "year")
incarc.pop[year==2017, c("total_pop_15to64","total_pop")] <- c(,)

  # They are equal. perfect, i can use the incarceration file instead

incarceration.perc.co <- incarc.pop %>% 
    mutate(jail.perc = jail_pop/total_pop_15to64 *100 ) %>%
    select(year, jail.perc)
View(incarceration.perc.co)

incarc.rate.vis <- ggplot(incarceration.perc.co, aes(x= year, y = jail.perc)) +
  geom_line() + 
  geom_point()+
  ggtitle('CO Incarceration Rate Over Time') +
  theme(
    plot.title = element_text(size=15, face="bold", family = "serif", hjust = 0.5 ),
    axis.title.x = element_text(vjust=-0.5, size = 15, family ="serif"),
    axis.title.y = element_text(vjust=0.75,family ="serif", size = 15),
    axis.text.x=element_text(angle=50, size=10, vjust=0.5, family ="serif"),
    axis.text.y=element_text(angle= 0, size=10, vjust=.05,family ="serif"),
    panel.background = element_rect(fill = 'white'),
    panel.grid.major = element_line(colour = "grey", size = .3, linetype = "dashed" ),
    panel.grid.minor = element_line(colour = "white", size = .5)
  ) + 
  ylim(0, .5) +
  scale_x_continuous(breaks = seq(2008, 2017, 1), limits = c(2008,2017)) +
  labs(x="Year", y="Incarceration Rate (% of State Population)")
incarc.rate.vis

### Interesting, interesting. so the percentage of the jail population of the overall
# state population is relatively constant
# Lets look at this at this at an individual county level

# Incarceration rates 2008-present
county.incarc.rate <- co_vera_data %>% select(year, county_name, total_pop, total_pop_15to64, 
                                             urbanicity, region, total_jail_pop) %>%
  mutate(incarc_perc = total_jail_pop/total_pop_15to64*100)
View(county.incarc.rate)

# Create Table of Incarceration rates by county and year 
county.incarc.table <- county.incarc.rate %>%
  select(year, county_name, incarc_perc) %>%
  spread(county_name, incarc_perc)

# Incarceration rates 2008-2015
county.incarc.rate.2008 <- county.incarc.rate %>% filter(year>2007 & year < 2016)

# Difference in incarceration rates 2015 - 2008
incarc.diff.15.08 <- county.incarc.rate %>% 
  filter(year == 2015 | year == 2008) %>% 
  select(year, county_name, incarc_perc) %>%
  mutate(diff2015.08 = incarc_perc -lag(incarc_perc, default = first(incarc_perc))) %>%
  filter(year == 2015) %>%
  select(county_name, diff2015.08) %>%
  mutate(changesign = ifelse(diff2015.08<0, "Less", "More"))


incarc.diff.15.08.plot  <- ggplot(incarc.diff.15.08,
                         aes(x=reorder(county_name, -diff2015.08), y=diff2015.08, fill=changesign)) + 
                        stat_summary(fun.y="sum", geom="bar", position="dodge") + coord_flip() +
                         labs(x="County", y="2015 Incarceration Perc - 2008 Incarceration Perc",
                            title="Change in Incarceration Percentage of County Population (2015 - 2008)"
                                                 ) +   
  theme(
                                                   plot.title = element_text(size=15, face="bold", family = "serif", hjust = 0.5 ),
                                                   axis.title.x = element_text(vjust=-0.5, size = 15, family ="serif"),
                                                   axis.title.y = element_text(vjust=0.75,family ="serif", size = 15),
                                                   axis.text.x=element_text(angle=0, size=10, vjust=0.5, family ="serif"),
                                                   axis.text.y=element_text(angle= 0, size=10, vjust=.05,family ="serif"),
                                                   panel.background = element_rect(fill = 'white'),
                                                   panel.grid.major = element_line(colour = "grey", size = .3, linetype = "dashed" ),
                                                   panel.grid.minor = element_line(colour = "white", size = .5)
                                                 ) + 
  guides(fill=FALSE)

incarc.diff.15.08.plot


########### 
# Maybe this can be more difference in difference (%change incarceration/%change population)
perc.change.data <- co_vera_data %>%
  select(year, county_name, total_pop_15to64, total_jail_pop) %>%
  filter(year == 2015 | year == 2008) %>%
  mutate(
    dif_15to64_pop = (total_pop_15to64 -lag(total_pop_15to64, default = first(total_pop_15to64)))*100/lag(total_pop_15to64, default = first(total_pop_15to64)),
    dif_jail_pop = (total_jail_pop - lag(total_jail_pop, default = first(total_jail_pop)))*100/lag(total_jail_pop, default = first(total_jail_pop))
    ) %>%
  filter(year == 2015) %>%
  select(county_name, dif_15to64_pop, dif_jail_pop) %>%
  mutate(
    dif_in_dif = dif_jail_pop/dif_15to64_pop,
    changesign = ifelse(dif_in_dif < 0, "Less", "More")
    ) #%>%
  #filter(abs(dif_in_dif) > 
  

dif.in.dif.plot  <- ggplot(filter(perc.change.data, abs(dif_in_dif) < 150 ) ,
                                  aes(x=reorder(county_name, -dif_in_dif), y=dif_in_dif, fill=changesign)) + 
  stat_summary(fun.y="sum", geom="bar", position="dodge") + coord_flip() +
  labs(x="County", y="Percentage Change in Jail Pop/Percentage Change in County Pop (2015 - 2008)",
       title="Percentage Change in Jail Population Relative to Percentage Change in County Population (2015 - 2008)"
  ) +   
  theme(
    plot.title = element_text(size=15, face="bold", family = "serif", hjust = 0.5 ),
    axis.title.x = element_text(vjust=-0.5, size = 15, family ="serif"),
    axis.title.y = element_text(vjust=0.75,family ="serif", size = 15),
    axis.text.x=element_text(angle=0, size=10, vjust=0.5, family ="serif"),
    axis.text.y=element_text(angle= 0, size=10, vjust=.05,family ="serif"),
    panel.background = element_rect(fill = 'white'),
    panel.grid.major = element_line(colour = "grey", size = .3, linetype = "dashed" ),
    panel.grid.minor = element_line(colour = "white", size = .5)
  ) + 
  guides(fill=FALSE)

dif.in.dif.plot


## Relative Change Plots

Rel.Change.plot  <- ggplot(filter(perc.change.data, abs(dif_in_dif) < 150 ) ,
                           aes(x= dif_15to64_pop, y=dif_jail_pop)) + 
  geom_point()+
  ggtitle('% Change in Incarceration v % Change in Population (2015 - 2008)') +
  theme(
    plot.title = element_text(size=15, face="bold", family = "serif", hjust = 0.5 ),
    axis.title.x = element_text(vjust=-0.5, size = 15, family ="serif"),
    axis.title.y = element_text(vjust=0.75,family ="serif", size = 15),
    axis.text.x=element_text(angle=0, size=10, vjust=0.5, family ="serif"),
    axis.text.y=element_text(angle= 0, size=10, vjust=.05,family ="serif"),
    panel.background = element_rect(fill = 'white'),
    panel.grid.major = element_line(colour = "grey", size = .5, linetype = "dashed" ),
    panel.grid.minor = element_line(colour = "grey", size = .3, linetype = "dashed")
  ) + 
  ylim(-75, 75) +
  scale_x_continuous(breaks = seq(-20, 20, 5), limits = c(-20,20)) +
  labs(x="% Change in Population", y="% Change in Jail Population") +
  geom_text(aes(label=county_name), hjust=-.1, vjust=.1, size = 2) +
  geom_hline(aes(yintercept = 0)) +
  geom_vline(aes(xintercept = 0)) +
  geom_abline(intercept = 0, slope = 1)


Rel.Change.plot



save.image("incarceration.explore.Rdata")










