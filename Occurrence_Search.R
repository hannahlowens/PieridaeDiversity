library(occCite)
library(dplyr)
library(rgbif)
library(rgdal)
library(raster)
library(ggplot2)
library(RefManageR)
library(viridis)

# Get list of taxa to search
table<-read.table("table.txt",header=F)
checklist<-as.character(table)

# Enter GBIF login information
login <- GBIFLoginManager(user = "your_user_id",
                           email = "your_email",
                           pwd = "your_password") # Your login

# Search for occurrence data for every taxon in the checklist
GBIFsearchList <- studyTaxonList(checklist, datasources = "GBIF Backbone Taxonomy")

sort(GBIFsearchList@cleanedTaxonomy$'Best Match')

gbifData <- occQuery(x = GBIFsearchList, 
                     GBIFLogin = login, datasources = "gbif",
                     GBIFDownloadDirectory = "change_location", # Location of all zip files
                     loadLocalGBIFDownload = T) # Tells occCite to look for local files

#Get and write citations
myOccCitations <- occCitation(gbifData)
sink("rawCitations.txt")
print(myOccCitations)
sink()

save.image(file='env2.RData') 
