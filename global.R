#####
##### global.R
##### Author: C.C.H.M. Maas
#####
library(shiny)           # shiny app
library(shinyjs)         # update after clicking calculate
library(shinydashboard)  # set up dashboards
library(dashboardthemes) # set theme

# set parameters for analysis
c.Breslow <- 0.7154091
center.Rec <- 2.031039
coef.Rec <- c(1.0264235, 0.3514440, 0.4914014, 0.2621760, 0.3803103,
              0.7062802, 0.8212041, 0.1866868, -0.3838754)
names(coef.Rec) <- c("SNstatus=Positive", "Age.SN", "Ulceration=Yes",
                     "Loc_CAT=leg", "Loc_CAT=trunk", "Loc_CAT=headneck",
                     "Breslow", "Rdamcrit", "SNstatus=Positive * Breslow")
h0.Rec <- 0.2534864
h0.MSM <- 0.1438848
MSM.cal.fact <- 1.0973015

# helper function converting input strings to numeric values
string.to.num <- function(input){
  # string to numeric
  if (input$SNstatus == "Positive"){
    SNstatus.num <- 1
  }
  else if (input$SNstatus == "Negative"){
    SNstatus.num <- 0
  }

  if (input$ulceration == "Yes"){
    Ulceration.num <- 1
  }
  else if (input$ulceration == "No"){
    Ulceration.num <- 0
  }

  location.arm <- 0
  location.leg <- 0
  location.trunk <- 0
  location.hn <- 0
  if (input$location == "Leg"){
    location.leg <- 1
  }
  else if (input$location == "Trunk"){
    location.trunk <- 1
  }
  else if (input$location == "Head and neck"){
    location.hn <- 1
  }

  return(list(SNstatus=SNstatus.num, ulceration=Ulceration.num, location.leg=location.leg,
              location.trunk=location.trunk, location.hn=location.hn))
}
