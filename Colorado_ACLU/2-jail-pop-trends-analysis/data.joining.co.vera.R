#### Lets join the VERA data to the Census Data for Colorado and see what happens
#
US.Census <- read_csv("censusSAIPEByCountyAndYear copy.csv")
co.census <- US.Census %>% filter(Abbreviation == "CO")
write.csv(co.census, file = "co.census.csv")

co_vera_data <-  read_csv("Colorado-Incarceration-Data.csv") # Details all Vera incarceration-trends data set for state of Colorado
View(co_vera_data)


co.vera.census <- inner_join(co.census, co_vera_data, by = c("fips", "year"))


View(co.vera.census)
View(co.census)
