

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
# or split it over administrative regions
# Make a script to get the hexagons over FI
#       12 km size (start with 50 km)
# get map for FI
# 



# Desired output:
# database of disturbed patches: year, age, zonation value
# database of undisturbed forests: random pick of location, to be able to compare it 



# --------------------------------------------------
# Create a forest raster for whole Finland:
# --------------------------------------------------

#   read files in zip files - 'walk' in tidyverse
#   create a mosaic
#   resample to 30 m res?
#   export as single raster: try to shhring down the size

library(tidyverse)  # to unzip all files 
library(terra)      # for raster processing
library(lubridate)


# Read files to UNZIP -------------------------------------
setwd('C:/Users/ge45lep/Documents/2022_disturba_Finland/')


# paths to folders
in_zip  = paste(getwd(), 'raw/FI_age_2015/2015/', sep = '/')
out_zip = 'C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/age_tif/'

# Read all files in directory
ls_zip <- list.files(in_zip, pattern = ".zip$", recursive = TRUE)

# walk throught all zip files and extract them all in respectives folders
walk(ls_zip, ~ unzip(zipfile = str_c(in_zip, .x), 
                         exdir = str_c(out_zip, .x)))


# Read all new RASTER files, stored in the subdirectories ---------------------------
setwd('C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/age_tif/')


# Read disturbance raster to resample the forest raster accordingly
dist <- rast("C:/Users/ge45lep/Documents/2022_disturba_Finland/raw/finland/finland/disturbance_year_1986-2020_finland.tif")

ls_tiff <- list.files(out_zip, pattern = ".tif$", recursive = TRUE)  # recursive = True goes into subdirectories

# Create a raster mosaic of all the rasters:
# first read and plot individual raster
# loop throught rasters 
# merge the tiles: from the LUKE map, the tiles are 3*12:
# r1 <- rast(paste(out_zip, 'ika_vmi1x_1216_L3.tif.zip/ika_vmi1x_1216_L3.tif', sep = ''))

# Read all files as rasters ! No needed to create a virtual raster!!
ls_rst <-   lapply(ls_tiff, function(x, ...) rast(paste(out_zip, x, sep = '')))


# Place the rasters as tiles in virtual raster -------------------------------------

# Create a temporary file to store virtual raster; just a file name
vrtfile2 <- paste0(tempfile(), ".vrt")

# Read the tiles into the raster = make a virtual raster
v <- vrt(ls_tiff,   # strings to individual files 
          vrtfile2, overwrite = T)  # string name of teh new file

head(readLines(vrtfile2)) 
v

# see the raster 
plot(v2)


# duplicate the raster to make a projections and change the CRS
dist_3067 <- dist
crs(dist_3067) <- 'epsg:3067'


# Resample v2 to 30x30, use bilinear 
v30 <- resample(v, dist_3067, method = 'bilinear') 

# Process virtual forest raster into the same CRS and resolution as disturbance data
# Change disturbance data into forest data crs: 3067 for Finland
# dist_3067 <- project(x = dist,  # which raster to transform
#                      crs = 'EPSG:3067',
#                      #y = v2,    # template for projection
#                      method = 'near'  # new raster values are based on nearest neighbr values, good for categorical data, bilinear is ok for continuous data
#                      )



# How to handle virtual raster: do I need to merge the data into one large file or not?
# simply try to clip it with hexagons and see


# get FI shp from natural earth data    -----------------------------------------
# Create large grid
# clip with disturbance maps??


library(rnaturalearth) # for map data
library(sf)


# get and  country data
fi_sf <- ne_states(country = "finland", 
                   returnclass = "sf")


st_crs(fi_sf)

# Check projection:
st_crs(fi_sf)$proj4string
st_crs(v2)$proj4string


# Make sure they have the same projection: 3037, Finnish projection
fi_sf <- st_transform(fi_sf,  st_crs(v2))

# Create a hexagonal grid covering the Finland
g = st_make_grid(fi_sf, 
                 cellsize = 50000,  # 50 km, value is in meters
                 square = FALSE)  # make hexagon, not square

plot(g)
plot(fi_sf, add = T)

st_crs(g)$proj4string  # seems that projection is correct



# How to evaluate the disturbance map? ------------------------------------------
# Keep only years from 2018, replace by NA
dist14 <- dist_3067
values(dist14)[values(dist14) < 2014 ] <- NA


writeRaster(dist14, 'dist14_3067.tiff', overwrite=TRUE)




# Try if possible to extract values from virtual grid: forest age?





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







# resample raster

r <- rast(nrows=3, ncols=3, xmin=0, xmax=10, ymin=0, ymax=10) 
values(r) <- 1:ncell(r) 
s <- rast(nrows=25, ncols=30, xmin=1, xmax=11, ymin=-1, ymax=11) 
x <- resample(r, s, method="bilinear") 


opar <- par(no.readonly =TRUE) 
par(mfrow=c(1,2)) 
plot(r) 
plot(x) 

par(opar)

