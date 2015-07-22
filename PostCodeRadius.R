##load library required for function(s) to operate
library("RCurl")
library("RJSONIO")
library("plyr")
library("pracma")
library("geosphere")
library("googleVis")


##first function to generate obtain Google API URL that will eventually generate 
##lat/long co-ords
url <- function(address, return.call = "json", sensor = "false") {
  
          root <- "http://maps.google.com/maps/api/geocode/"
          u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
          return(URLencode(u))
   }

geoCode <- function(address) {
       u <- url(address)
       doc <- getURL(u)
       x <- fromJSON(doc,simplify = FALSE)
       if(x$status=="OK") {
             lat <- x$results[[1]]$geometry$location$lat
             lng <- x$results[[1]]$geometry$location$lng
             return(c(lat, lng))
         } else {
               return(c(NA,NA))
           }
   }

Dist.Calc <- function(address1, address2)
                
                {
                  
                  address1 <- geoCode(address1)
                  
                  address2 <- geoCode(address2)
                  
                  dist <- distHaversine(address1,address2)/1000
                  
                  return(dist)
  
                }

PostCode.Radius <- function(address, r = 30, km = TRUE, rad = 6371, map = TRUE)
{
  if (length(address) != 1 & map == TRUE){
    stop("Can only use one address and plot a map!")
  }
  
  if (km == FALSE)
  {
    rad <- rad*0.621371192
  }
  
  if (exists("raw.data") == FALSE)
  {
    raw.data <<- read.csv(file.choose()) 
  }
  
  PostCode.List <- matrix(address, nrow = length(address), 1)
  
  for (i in address)
    
    {
  
                    lng <- geoCode(i)[2]
                    
                    lat <- geoCode(i)[1]
                    
                    maxlat <- lat + rad2deg(r/rad)
                    minlat <- lat - rad2deg(r/rad)
                    
                    if (lng < 0)
                    {
                      maxlng <- lng + rad2deg(r/rad/cos(lat))
                      minlng <- lng - rad2deg(r/rad/cos(lat))
                    }
                    else
                    {
                      maxlng <- lng - rad2deg(r/rad/cos(lat))
                      minlng <- lng + rad2deg(r/rad/cos(lat))
                    }

                    data <- raw.data[which(raw.data[,2] >= minlat
                                      & raw.data[,2] <= maxlat
                                      & raw.data[,3] >= minlng
                                      & raw.data[,3] <= maxlng),]
                    
                    data <- data[which(acos(sin(deg2rad(lat))*sin(deg2rad(data[,2])) + cos(deg2rad(lat))*cos(deg2rad(data[,2]))*cos(deg2rad(data[,3]-lng))) * rad < r),]
                    
                    tmp.PostCodes <- matrix(data[,1], nrow(data), 1)
                    
                    PostCode.Matrix <- list(PostCode.List,tmp.PostCodes)
                    
                    PostCode.Matrix <- lapply(PostCode.Matrix, as.matrix)
                    
                    Matrix.Length <- max(sapply(PostCode.Matrix, nrow))
                    
                    PostCode.List <- do.call(cbind, lapply(PostCode.Matrix, function (x) 
                                rbind(x, matrix(, Matrix.Length-nrow(x), ncol(x)))))                                        
                   
                    
  }

  PostCode.List <- as.data.frame(PostCode.List)
  
  PostCode.List[,1] <- NULL
  
  colnames(PostCode.List) <- address
  
  write.csv(PostCode.List, "PostCodeList.csv", na = "", row.names = FALSE)
  
  if (map == TRUE){
    
    if(ncol(PostCode.List) == 1) {
      
      PostCode.List[["tipVar"]] <- PostCode.List[,1]
      
    }
    
    PostCode.List[["country"]] <- paste(data[,2], ":", data[,3], sep = "")
    
    map <- gvisMap(PostCode.List,locationvar = "country" ,options = list(enableScrollWheel = TRUE, showTip = TRUE, mapType = "normal",width = 550, height = 900))
    
    plot(map) 
  } 
}