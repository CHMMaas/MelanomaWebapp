#####
##### global.R
##### Author: C.C.H.M. Maas
#####

# set parameters for analysis
# load("Z:/Project Melanoom/PaperMelanoma/Results/h0.Rec.MSM.Rdata")
options(digits=8)
c.Breslow <- 0.71721686
center.Rec <- 1.084093
coef.Rec <- c(1.0756086189, 0.0082653245, 0.4680218484,
              0.2590865107, 0.3789697619, 0.6807525719, 
              0.8827736434, 0.1988932596, -0.4522583367)
names(coef.Rec) <- c("SNstatus=Positive", "Age.SN", "Ulceration=Yes",
                     "Loc_CAT=leg", "Loc_CAT=trunk", "Loc_CAT=headneck",
                     "Breslow", "Rdamcrit", "SNstatus=Positive * Breslow")
h0.Rec <- 0.20469555
h0.MSM <- 0.089604541
MSM.cal.fact <- 1.1279159

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
