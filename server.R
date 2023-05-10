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

    output$recurrence_box <- shinydashboard::renderInfoBox({
      # calculate LP score
      num.input <- string.to.num(input)
      lp <- coef.Rec["SNstatus=Positive"]*num.input$SNstatus+
        coef.Rec["Age.SN"]*input$age+
        coef.Rec["Ulceration=Yes"]*num.input$ulceration+
        coef.Rec["Loc_CAT=leg"]*num.input$location.leg+
        coef.Rec["Loc_CAT=trunk"]*num.input$location.trunk+
        coef.Rec["Loc_CAT=headneck"]*num.input$location.hn+
        coef.Rec["Breslow"]*(log(input$breslow)-c.Breslow)+
        coef.Rec["Rdamcrit"]*log(input$tumburden)+
        coef.Rec["SNstatus=Positive * Breslow"]*(log(input$breslow)-c.Breslow)*num.input$SNstatus-center.Rec

      # calculate corresponding probability
      h.Rec <- h0.Rec*exp(lp)
      # p.Rec <- 1-exp(-h.Rec)
      p.RFS <- exp(-h.Rec)

      # display probability
      shinydashboard::infoBox("Recurrence-free survival is",
              paste0(sprintf("%.0f", p.RFS*100), "%"), icon = icon("chart-line"), color = "blue"
      )
    })

    output$MSM_box <- shinydashboard::renderInfoBox({
      # # calculate LP score
      num.input <- string.to.num(input)
      lp <- coef.Rec["SNstatus=Positive"]*num.input$SNstatus+
        coef.Rec["Age.SN"]*input$age+
        coef.Rec["Ulceration=Yes"]*num.input$ulceration+
        coef.Rec["Loc_CAT=leg"]*num.input$location.leg+
        coef.Rec["Loc_CAT=trunk"]*num.input$location.trunk+
        coef.Rec["Loc_CAT=headneck"]*num.input$location.hn+
        coef.Rec["Breslow"]*(log(input$breslow)-c.Breslow)+
        coef.Rec["Rdamcrit"]*log(input$tumburden)+
        coef.Rec["SNstatus=Positive * Breslow"]*(log(input$breslow)-c.Breslow)*num.input$SNstatus-center.Rec

      # calculate corresponding probability
      h.MSM <- h0.MSM*exp(MSM.cal.fact*lp)
      # p.MSM <- 1-exp(-h.MSM)
      p.MSS <- exp(-h.MSM)

      # display probability
      shinydashboard::infoBox("Melanoma-specific survival is",
              paste0(sprintf("%.0f", p.MSS*100), "%"), icon = icon("heart"), color = "blue"
      )
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
