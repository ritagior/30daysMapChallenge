## Day 4 Colour Friday: Green

library(tidyverse)
library(sysfonts)
library(showtext)

## import lexend font from google

font_add_google(name = "Lexend",
                family = "sans-serif")

showtext_auto()
## reforestation data
refor <- read_csv("30DaysMapChallenge/data/fra2020-annualReforestation.csv",
                  skip = 1,
                  col_names = TRUE)
## Remove all the text between parenthesis
refor_tidy <- refor %>%
  rename(region = "...1") %>%
  mutate(region = str_replace(region, "\\s*\\([^\\)]+\\)", ""))

world <- map_data("world")
world_reforestation <- left_join(world, refor_tidy,
                                 by = "region") %>%
  distinct() %>%
  filter(!region == "Antarctica")
## create subtitle for the map
sub = str_wrap(
  "The increase of reforestation can reduce the global warming. As benefit could help to capture atmosperic carbon ad reducit up top 25%. Reforestation could be one of the most effective strategy for climate change mitigation."
  )
ggplot(data = world_reforestation,
       aes(map_id = region, x = long, y = lat,
           fill = `2015-2020`,
           colour = 'grey95')) +
  geom_map(map = world_reforestation,
           aes(color = "white"),
           size = 0.25) +
  theme_void() +
  scale_fill_distiller(palette = "Greens",
                       direction = 1,
                       name = "Reforestation") +
  scale_colour_manual(values = "grey95",
                      name = "No data",
                      labels = "") +
  guides(fill = guide_coloursteps(
    title.position = "bottom",
    title = "1000 ha/year"
    )) +
  theme(legend.position = "bottom",
        legend.text.align = 0,
        plot.caption.position = "panel",
        plot.caption = element_text(hjust = 0.98),
        plot.title = element_text(hjust = 0.5,
                                  face = "bold",
                                  size = 22),
        plot.subtitle = element_text(hjust = 0.5)) +
  labs(title = "Annual Reforestation, in 1000 ha/year, per country, from 2015 to 2020",
       subtitle = sub,
       caption = "Source: fra-data.fao.org, Science 2019,Vol 365, Issue 6448, pp. 76-79" ) +
  coord_cartesian(clip = "off")

