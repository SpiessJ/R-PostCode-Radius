# R-PostCode-Radius
R function that will take a postcode(s) and generate a list of other postcodes within a given radius in km/miles.

## Installation

Run the following dependancy installations prior to running function.

install.packages("RCurl")
<br>install.packages("RJSONIO")
<br>install.packages("plyr")
<br>install.packages("pracma")
<br>install.packages("geosphere")
<br>install.packages("googleVis")
<p>And run the following to add functions to R session. This assumes the function has been saved in current working directory.
<p>source("PostCodeRadius.R")

## Instructions

The R file contains four R functions; url(), geoCode(), Dist.Calc(), and PostCode.Radius()
<p>While url() & geoCode() are used, and therefore required, for the main PostCode.Radius() function Disc.Calc() is a stand alone function that calculates the distance as the crow flys between two postcodes.
<p>The main function PostCode.Radius() appears as the following:
<p>PostCode.Radius(address, r = 30, km = TRUE, rad = 6371, map = TRUE)
<p>address <- postcode given as either a single character string or a vector of postcodes. Length of vector is only limited by Google API limitations
<br>r <- radius around postcode(s) you wish to use, default is 30
<br>km <- bolean of whether to use km's or not as unit of measure. To use miles use km = FALSE
<br>rad <- the radius of the earth in km's. Default is given as 6371. If miles are selected this will be changed in the script
<br>map <- bolean of whether a map should be plotted using Google maps. If length of address > 1 then cannot plot map.

<p>The first time this function the file dialog box will appear to allow you to select the UKPostCode.csv file. Once this has been added to the R workspace it won't need to be load again, assuming you dont clear the workspace!

## Example

PostCode.Radius(address = "SP4 7DE", r = 30, km = TRUE, rad = 6371, map = TRUE)
<p>This will produce a csv file within your R working directory of all the postcodes within that radius.
