

# Valuable habitats loss in Finland

# RQ: are we loosing teh most valuable habitats?
# eg. is the loss faster in more valuable stands?
# are more valuable stands also older?   

# Steps - develop over individual scripts


# Aim: develop the input data for Pihla for following processing 

# Create tile for the forest age: 2015 - make a raster mosaics from tiles
#   download data from LUKE: 
#   manually, from 2015: https://kartta.luke.fi/opendata/valinta-en.html  
# Analyse the disturbance data - Finland from Cornelius:
#   dopwnload from: https://zenodo.org/record/4746129#.YjCu5zGZMuU
# analyse them by the grid of different size? I suggest yes
# Make a script to get the hexagons over FI
#       12 km size
# get map for FI



# --------------------------------------------------
# Create a forest raster for whole Finland:
# --------------------------------------------------

#   read files in zip files - 'walk' in tidyverse
#   create a mosaic
#   resample to 30 m res?
#   export as single raster: try to shhring down the size

library(tidyverse)  # to unzip all files 


library(terra)  # for raster processing



# Read files to UNZIP 
setwd('C:/Users/ge45lep/Documents/2022_disturba_Finland/')

# 
in_zip  = paste(getwd(), 'raw/FI_age_2015/2015/', sep = '/')
out_zip = 'C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/age_tif/'

# Read all files in directory
ls_zip <- list.files(in_zip, pattern = ".zip$", recursive = TRUE)

# walk throught all zip files and extract them all in respectives folders
walk(ls_zip, ~ unzip(zipfile = str_c(in_zip, .x), 
                         exdir = str_c(out_zip, .x)))


# Read all new RASTER files, stored in the subdirectories
setwd('C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/age_tif/')
ls_tiff <- list.files(out_zip, pattern = ".tif$", recursive = TRUE)  # recursive = True goes into subdirectories

# Read data as rasters
ls_rst <- lapply(ls_tiff, rast)


# Create a raster mosaic of all the rasters:
# first read and plot individual raster
# loop throught rasters 
# merge the tiles: from the LUKE map, the tiles are 3*12:
# r1 <- rast(paste(out_zip, 'ika_vmi1x_1216_L3.tif.zip/ika_vmi1x_1216_L3.tif', sep = ''))

# Read all files as rasters
ls_rst <-   lapply(ls_tiff, function(x, ...) rast(paste(out_zip, x, sep = '')))


# Place the rasters as tiles



# Make my example?
# Create a new temporary virtual rasters
vrtfile2 <- paste0(tempfile(), ".vrt")

# Read the tiles into the raster
v2 <- vrt(ls_tiff, vrtfile2) 
head(readLines(vrtfile2)) 
v2

plot(v2)

library(dplyr)
df %>% 
  filter(year > 2014)



# ----------------------------------
#     Dummy examples                    
# ----------------------------------




# Test a dummy example how to make it: what is a virtual raster?
# how to storre raster tiles?

r <- rast(ncols=100, nrows=100) 
values(r) <- 1:ncell(r) 
x <- rast(ncols=2, nrows=2) 
filename <- paste0(tempfile(), "_.tif") 
ff <- makeTiles(r, x, filename) 
ff

vrtfile <- paste0(tempfile(), ".vrt")

v <- vrt(ff, vrtfile) 
head(readLines(vrtfile)) 
v



