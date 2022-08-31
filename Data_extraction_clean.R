library(occCite)
library(raster)

setwd("WORKING_DIRECTORY")

# Load occurrence data ----
pieridData <- list.files(pattern = ".csv", full.names = T)
spNames <- gsub(list.files(pattern = ".csv", full.names = F), pattern = "_noDuplicates.csv", replacement = "")
pieridData <- lapply(pieridData, FUN = function(x) read.csv(x))

# Get environmental data ----
variable <- raster("Path to WorldClim variable file")

#change working directory

for (i in 1:length(pieridData)){
  print(paste0("Extracting ", spNames[[i]], ", ", nrow(pieridData[[i]]), " point(s)"))
  coords <- pieridData[[i]][,c("decimalLongitude", "decimalLatitude")]
  envtExt <- raster::extract(x = envtSt, y = coords)
  resultTable <- cbind(pieridData[[i]][,"scientificName"], coords, envtExt)
  colnames(resultTable)[[1]] <- "scientificName"
  write.csv(resultTable, file = paste0(spNames[[i]], "_extractedVariables.csv"), row.names = F)
}


