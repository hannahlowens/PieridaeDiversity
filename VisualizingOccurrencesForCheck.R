library(ggplot2)
library(ggmap)
library(rnaturalearth)
library(dplyr)
library(grid)
library(stringr)

# Map occurrences
occMap <- function(occ_dat){
  
  world <- ne_countries(scale = "medium", returnclass = "sf", type = "countries")

  occ_map <- ggplot() +
    geom_sf(data = world, color = "black", fill = "gray") +
    geom_point(data = occ_dat, aes(x = decimalLongitude, y = decimalLatitude),
               colour = "#bd0026", shape = 20, alpha = 2/3) + 
    xlab("Longitude") +
    ylab("Latitude") +
    ggtitle(paste0(occ_dat$scientificName[1], ", ", nrow(occ_dat), " points"))
  return(occ_map)
}

# This makes tidy plots. It's usually to do more than one plot per page, but you'll only get one plot.
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

PATH <- "~/Dropbox/Pieridae/"

pdf(file = "occurrencePreview.pdf")
occs <- list.files(path = PATH, pattern = ".csv", full.names = T) # Change path to .csv file folder
rawCounts <- vector(mode = "list", length = length(occs))
occCounts <- vector(mode = "list", length = length(occs))
for (sp in occs){
  oc <- read.csv(sp)
  if (!is.na(any(match(colnames(oc), "decimalLon")))) {
    colnames(oc) <- gsub("decimalLon", "decimalLongitude", 
                         gsub("decimalLat", "decimalLatitude", 
                              gsub("scientific", "scientificName", colnames(oc))))
  }
  if (is.na(any(match(colnames(oc), "decimalLongitude")))) {
    colnames(oc) <- gsub("longitude", "decimalLongitude", 
                         gsub("latitude", "decimalLatitude", 
                              gsub("scientific", "scientificName", colnames(oc))))
  }
  
  rawCounts[[match(sp, occs)]] <- nrow(oc)
  oc$decimalLongitude <- round(oc$decimalLongitude, digits = 4) # Round to four decimal places
  oc$decimalLatitude <- round(oc$decimalLatitude, digits = 4) # Round to four decimal places
  if (nrow(oc) > 1) oc <- oc %>% distinct(scientificName, decimalLatitude, decimalLongitude, source) # Removes duplicates
  occCounts[[match(sp, occs)]] <- nrow(oc)
  
  #Write de-duplicated occurrences to new file
  write.csv(oc, 
            file = paste0("PATH", 
                          oc$scientificName[1], 
                          "_noDuplicates.csv"), 
            row.names=F)
  
  if (nrow(oc) > 1){
    p1 <- occMap(oc)
    multiplot(p1, cols=1)
  }
  print(paste0(oc$scientificName[1], " has ", nrow(oc), " points."))
}
dev.off()

postVisOccs <- cbind(stringr::str_extract(occs, pattern = "\\w*\\s\\w*"),rawCounts, occCounts)
write.csv(postVisOccs, "postVisualizationOccurrenceCounts.csv", row.names = F)
