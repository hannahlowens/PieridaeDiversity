# PieridaeDiversity
Scripts for Carvalho et al., "Evolution of pierid butterflies reveals correlations between of speciation and global temperature".

* `Occurrence_Search.R` reads a `.txt` list of taxa, searches the Global Biodiversity Information Facility (GBIF) database for occurrences for every species in the list, and generates citations for the occurrence data in accordance with GBIF's recommendations for best citation practices.

* `VisualizingOccurrencesForCheck.R` automatically reads all occurrence `.csv` files in a specified folder, rounds occurrence coordinates to four decimal points, removes duplicate results, and creates a `.pdf` atlas of clearn occurrences for each species.
