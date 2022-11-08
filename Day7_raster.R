# Raster data
library(raster)
library(rgdal)
library(tidyverse)

path <- "30DaysMapChallenge/data/"
soil_moisture <- capture.output(
  GDALinfo(paste0(path,"SM_5x5km_LongTerm_mean_GS_00_19_crs3035.tif"))
  )

## Open tif file using raster function
SM_deficit <- raster(
  paste0(path, "SM_5x5km_LongTerm_mean_GS_00_19_crs3035.tif")
  )

## summary statistics, use maxsamp to force calculation.
summary(SM_deficit, maxsamp = ncell(SM_deficit))

## Convert the raster data into a dataframe to visualise with ggplot2.
SM_deficit_df <- as.data.frame(SM_deficit, xy = TRUE)

## Plot the data
SM_deficit_df
  ggplot() +
  geom_raster(data = SM_deficit_df, aes(x,
                  y,
                  fill = SM_5x5km_LongTerm_mean_GS_00_19_crs3035)) +

  scale_fill_distiller(palette = "RdYlBu",
                       direction = 1,
                       name = "Soil moisture",
                       na.value = "gray99",
                       labels = c("dry", 0.25, 0.5, 0.75, "wet")) +
  guides(fill = guide_colourbar(
    title.position = "top",
    title = "Soil moisture",
  )) +
  coord_quickmap(clip = "off") +
  #theme_void() +
  theme(legend.position = "right",
        legend.text = element_text(hjust = 0.5),
        # plot.background = element_rect(
        #   fill = "gray99", colour = "gray99"
        #   ),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_blank(),
        #panel.background = element_blank(),
        # panel.background = element_rect(
        #   fill = "gray99", colour = "gray99"
        # ),
        #legend.margin = margin(0,-300,0,-100),
        plot.margin=grid::unit(c(0,0,0,0), "mm"),
        plot.title = element_text(
          hjust = 0.5,
          face = "bold",
          size = 18
          ),
        plot.subtitle = element_text(
          hjust = 0.5,
          size = 16
        ),
        plot.caption = element_text(
          size = 10,
          hjust = 0
        ),
        plot.caption.position = "panel"
      ) +
    labs(
      title = "Soil moisture deficit during the vegetation growing season",
      subtitle = "Annual time series 2000 - 2019",
      caption = "High value of soil moisture indicate wet, while low values indicate dry soil.      Source: EEA geospatial data catalogue"
        )

