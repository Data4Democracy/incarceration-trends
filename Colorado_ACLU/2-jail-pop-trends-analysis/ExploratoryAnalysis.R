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
incarceration <- read.xlsx("colorado-incarceration-hist.xlsx",1)[,-3] # Details Jail population by year from the Veri incarceration-trends data set

# Analysis Steps #
##################









