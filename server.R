shiny::shinyServer(
  function(input, output, session){
    observe ({
      if (input$SNstatus=="Negative"){
        updateSliderInput(session=session, inputId="tumburden", value=1)
        shinyjs::disable("tumburden")
      } else if (input$SNstatus=="Positive"){
        shinyjs::enable("tumburden")
      }
    })
    
    observeEvent(input$breslow, {
      if (input$breslow>0.8){
        updateSelectInput(session, inputId="ulceration", choices=c("No", "Yes"))
      } else if (input$breslow<=0.8){
        updateSelectInput(session, inputId="ulceration", choices=c("Yes"))
      }
    })

    output$recurrence_box <- shinydashboard::renderInfoBox({
      # calculate LP score
      location.text <- transform.location(input$location)
      
      # make prediction
      prediction <- rms::Predict(f.mi.BS.Rec.5, 
                            SNstatus=input$SNstatus,
                            Age.SN=input$age,
                            Ulceration=input$ulceration,
                            Loc_CAT=location.text,
                            Breslow=input$breslow,
                            Rdamcrit=input$tumburden)
      lp <- prediction[, "yhat"]
      lp.lower <- prediction[, "lower"]
      lp.upper <- prediction[, "upper"]
      
      # calculate score
      score <- as.numeric((lp-int.Rec)/rc.Rec)
      score <- ifelse(score>max.range, max.range, score)
      
      # revert back to lp
      lp.trunc <- lp # as.numeric(score*rc.Rec+int.Rec)
      
      # shift limits
      lp.trunc.lower <- lp.lower + (lp.trunc-lp)
      lp.trunc.upper <- lp.upper + (lp.trunc-lp)
      
      # calculate corresponding probability
      p.RFS <- exp(-h0.Rec*exp(lp.trunc))
      p.RFS.lower <- exp(-h0.Rec*exp(lp.trunc.lower))
      p.RFS.upper <- exp(-h0.Rec*exp(lp.trunc.upper))
      if (p.RFS.lower>p.RFS.upper){
        p.RFS.upper <- exp(-h0.Rec*exp(lp.trunc.lower))
        p.RFS.lower <- exp(-h0.Rec*exp(lp.trunc.upper))
      }
      
      # display probability
      shinydashboard::infoBox("5-year recurrence-free survival is",
              value=paste0(sprintf("%.1f", p.RFS*100), "%"),
              subtitle=paste0("95% CI: [", sprintf("%.1f", p.RFS.lower*100),
                     "%; ", sprintf("%.1f", p.RFS.upper*100), "%]"),
              icon = icon("chart-line"), color = "blue")
    })

    output$MSM_box <- shinydashboard::renderInfoBox({
      # calculate LP score
      location.text <- transform.location(input$location)
      
      # make prediction
      prediction <- rms::Predict(f.mi.BS.Rec.5, 
                                 SNstatus=input$SNstatus,
                                 Age.SN=input$age,
                                 Ulceration=input$ulceration,
                                 Loc_CAT=location.text,
                                 Breslow=input$breslow,
                                 Rdamcrit=input$tumburden)
      lp <- prediction[, "yhat"]
      lp.lower <- prediction[, "lower"]
      lp.upper <- prediction[, "upper"]
      
      # calculate score
      score <- as.numeric((lp-int.Rec)/rc.Rec)
      score <- ifelse(score>max.range, max.range, score)
      
      # revert back to lp
      lp.trunc <- lp #as.numeric(score*rc.Rec+int.Rec)
      
      # shift limits
      lp.trunc.lower <- lp.lower + (lp.trunc-lp)
      lp.trunc.upper <- lp.upper + (lp.trunc-lp)
      
      # calculate corresponding probability
      p.MSS <- exp(-h0.Rec*exp(MSM.cal.fact*lp.trunc))
      p.MSS.lower <- exp(-h0.Rec*exp(MSM.cal.fact*lp.trunc.lower))
      p.MSS.upper <- exp(-h0.Rec*exp(MSM.cal.fact*lp.trunc.upper))
      if (p.MSS.lower>p.MSS.upper){
        p.MSS.upper <- exp(-h0.Rec*exp(MSM.cal.fact*lp.trunc.lower))
        p.MSS.lower <- exp(-h0.Rec*exp(MSM.cal.fact*lp.trunc.upper))
      }
      
      # display probability
      shinydashboard::infoBox("5-year melanoma-specific survival is",
                              value=paste0(sprintf("%.1f", p.MSS*100), "%"),
                              subtitle=paste0("95% CI: [", sprintf("%.1f", p.MSS.lower*100),
                                          "%; ", sprintf("%.1f", p.MSS.upper*100), "%]"),
                              icon = icon("chart-line"), color = "blue")
    })

    observeEvent(input$calculateButton, {
      shinyjs::show("results.panel")
    })

    observeEvent({
      input$SNstatus
      input$age
      input$ulceration
      input$location
      input$breslow
      input$tumburden
    }, {
      shinyjs::hide("results.panel")
    })
  }
)
