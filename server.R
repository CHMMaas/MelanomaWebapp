shiny::shinyServer(
  function(input, output, session){
    observe ({
      if (input$SNstatus=="Negative"){
        updateSliderInput(session=session, inputId="tumburden", value=1)
        shinyjs::disable("tumburden")
      } else if (input$SNstatus=="Positive"){
        enable("tumburden")
      }
    })

    output$recurrence_box <- shinydashboard::renderInfoBox({
      # calculate LP score
      num.input <- string.to.num(input)
      lp <- coef.Rec["SNstatus=Positive"]*num.input$SNstatus+
        coef.Rec["Age.SN"]*log(input$age)+
        coef.Rec["Ulceration=Yes"]*num.input$ulceration+
        coef.Rec["Loc_CAT=leg"]*num.input$location.leg+
        coef.Rec["Loc_CAT=trunk"]*num.input$location.trunk+
        coef.Rec["Loc_CAT=headneck"]*num.input$location.hn+
        coef.Rec["Breslow"]*(log(input$breslow)-c.Breslow)+
        coef.Rec["Rdamcrit"]*log(input$tumburden)+
        coef.Rec["SNstatus=Positive * Breslow"]*(log(input$breslow)-c.Breslow)*num.input$SNstatus-center.Rec

      # calculate corresponding probability
      h.Rec <- h0.Rec*exp(lp)
      p.Rec <- 1-exp(-h.Rec)

      # display probability
      infoBox("Recurrence is",
              paste0(sprintf("%.0f", p.Rec*100), "%"), icon = icon("chart-line"), color = "blue"
      )
    })

    output$MSM_box <- shinydashboard::renderInfoBox({
      # # calculate LP score
      num.input <- string.to.num(input)
      lp <- coef.Rec["SNstatus=Positive"]*num.input$SNstatus+
        coef.Rec["Age.SN"]*log(input$age)+
        coef.Rec["Ulceration=Yes"]*num.input$ulceration+
        coef.Rec["Loc_CAT=leg"]*num.input$location.leg+
        coef.Rec["Loc_CAT=trunk"]*num.input$location.trunk+
        coef.Rec["Loc_CAT=headneck"]*num.input$location.hn+
        coef.Rec["Breslow"]*(log(input$breslow)-c.Breslow)+
        coef.Rec["Rdamcrit"]*log(input$tumburden)+
        coef.Rec["SNstatus=Positive * Breslow"]*(log(input$breslow)-c.Breslow)*num.input$SNstatus-center.Rec

      # calculate corresponding probability
      h.MSM <- h0.MSM*exp(MSM.cal.fact*lp)
      p.MSM <- 1-exp(-h.MSM)

      # display probability
      infoBox("Melanoma-specific mortality is",
              paste0(sprintf("%.0f", p.MSM*100), "%"), icon = icon("heart"), color = "blue"
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
