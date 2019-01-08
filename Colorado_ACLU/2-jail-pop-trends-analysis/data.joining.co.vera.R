#### Lets join the VERA data to the Census Data for Colorado and see what happens
#
US.Census <- read_csv("censusSAIPEByCountyAndYear copy.csv")
co.census <- US.Census %>% filter(Abbreviation == "CO")
write.csv(co.census, filename = "co.census")

View(co.census)