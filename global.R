#####
##### global.R
##### Author: C.C.H.M. Maas
#####

# set parameters for analysis
load("./model.Rdata")
options(digits=8)

# helper function converting input strings to values used in development
transform.location <- function(location){
  location.text <- "arm"
  if (location == "Lower limb"){
    location.text <- "leg"
  }
  else if (location == "Trunk"){
    location.text <- "trunk"
  }
  else if (location == "Head and neck"){
    location.text <- "head & neck"
  }

  return(location.text)
}
