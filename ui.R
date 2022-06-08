shiny::shinyUI(
  shinydashboard::dashboardPage(
    shinydashboard::dashboardHeader(title = "Calculator"),
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem("Dashboard", tabName = "dashboard", icon = icon("calculator")),
        shinydashboard::menuItem("About", tabName = "abstract", icon = icon("info-circle")),
        shinydashboard::menuItem("Model", tabName = "model", icon = icon("toolbox")),
        shinydashboard::menuItem("Supplier", tabName = "supplier", icon = icon("tools"))
      )
    ),
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "dashboard",
                dashboardthemes::shinyDashboardThemes(theme = "grey_light"),
                shiny::fluidPage(
                  shinyjs::useShinyjs(),
                  shinydashboard::box(width = 6,
                      title = "Adjust the patient characteristics",
                      solidHeader = FALSE, status = "primary",
                      shiny::selectInput("SNstatus", "Positive or negative sentinel node status",
                                  choices = c("Negative", "Positive")),
                      shiny::sliderInput("age", "Enter the age at which the patient was diagnosed",
                                  20, 80, 55),
                      shiny::selectInput("ulceration", "Ulceration",
                                  choices = c("No", "Yes")),
                      shiny::selectInput("location", "Enter the location of the metastasis",
                                  choices = c("Arm", "Leg", "Trunk", "Head and neck")),
                      shiny::sliderInput("breslow", "Enter the Breslow thickness",
                                  min=0.1, max=7, value=0.1, step=0.1),
                      shiny::sliderInput("tumburden", "Select the level of tumour burden",
                                  0.01, 9, 1),
                      shiny::actionButton(inputId = "calculateButton", label = "Calculate", icon=icon("calculator"),
                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                  ),
                  shinyjs::hidden(
                    div(
                      id="results.panel",
                      shiny::conditionalPanel(condition="calculateButton",
                        shinydashboard::box(width = 6,
                                           title = "Probability of",
                                           solidHeader = FALSE, status = "info",
                                           shinydashboard::infoBoxOutput("recurrence_box", width = 12),
                                           shinydashboard::infoBoxOutput("MSM_box", width = 12))),
                      shiny::conditionalPanel(condition="calculateButton",
                         shinydashboard::box(width = 12,
                                           title = "Disclaimer",
                                           solidHeader = FALSE, status = "warning",
                                           includeHTML("html/disclaimer.html")))
                    )
                  )
                )
        ),
        shinydashboard::tabItem(tabName = "abstract",
                h2("Abstract"),
                includeHTML("html/abstract.html")),
        shinydashboard::tabItem(tabName = "model",
                h2("Model"),
                includeHTML("html/model.html")),
        shinydashboard::tabItem(tabName = "supplier",
                includeHTML("html/supplier.html"))
      )
    )
  )
)
