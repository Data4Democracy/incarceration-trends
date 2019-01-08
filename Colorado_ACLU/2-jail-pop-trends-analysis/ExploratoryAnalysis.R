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
incarceration <- read.xlsx("colorado-incarceration-hist.xlsx",1)[,-3] # Details Jail population by year from the Vera incarceration-trends data set

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












