shiny::shinyUI(
  shinydashboard::dashboardPage(
    shinydashboard::dashboardHeader(title = "Melanoma Webapp"),
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem("Dashboard", tabName = "dashboard", icon = icon("calculator")),
        shinydashboard::menuItem("About", tabName = "abstract", icon = icon("info-circle")),
        shinydashboard::menuItem("Model", tabName = "model", icon = icon("toolbox")),
        shinydashboard::menuItem("Disclaimer", tabName = "disclaimer", icon = icon("exclamation")),
        shinydashboard::menuItem("Supplier", tabName = "supplier", icon = icon("tools"))
      )
    ),
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "dashboard",
                dashboardthemes::shinyDashboardThemes(theme = "grey_light"),
                shiny::fluidPage(
                  shinyjs::useShinyjs(),
                  shinydashboard::box(width = 12,
                                      title = "Disclaimer",
                                      solidHeader = FALSE, status = "warning",
                                      includeHTML("html/small_disclaimer.html")),
                  shinydashboard::box(width = 6,
                      title = "Adjust the patient characteristics",
                      solidHeader = FALSE, status = "primary",
                      shiny::selectInput("SNstatus", "Positive or negative sentinel node status",
                                  choices = c("Positive", "Negative")),
                      shiny::sliderInput("breslow", "Enter the Breslow thickness (in mm)",
                                         min=0.1, max=7, value=1, step=0.1),
                      shiny::sliderInput("age", "Enter the age (years) at which the patient underwent the sentinel node procedure",
                                  20, 80, 55),
                      shiny::selectInput("ulceration", "Ulceration",
                                  choices = c("No", "Yes")),
                      shiny::selectInput("location", "Enter the location of the metastasis",
                                  choices = c("Upper limb", "Lower limb", "Trunk", "Head and neck")),
                      shiny::sliderInput("tumburden",
                                         "Enter the maximum diameter of the largest SN metastasis (in mm)",
                                         0.01, 9, 1),
                      shiny::actionButton(inputId = "calculateButton", label = "Calculate", icon=icon("calculator"),
                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                  ),
                  shinyjs::hidden(
                    div(
                      id="results.panel",
                      shiny::conditionalPanel(condition="calculateButton",
                        shinydashboard::box(width = 6,
                                           title = "Results",
                                           solidHeader = FALSE, status = "info",
                                           shinydashboard::infoBoxOutput("recurrence_box", width = 12),
                                           shinydashboard::infoBoxOutput("MSM_box", width = 12)))
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
        shinydashboard::tabItem(tabName = "disclaimer",
                                h2("Disclaimer"),
                                includeHTML("html/disclaimer.html")),
        shinydashboard::tabItem(tabName = "supplier",
                includeHTML("html/supplier.html"))
      )
    )
  )
)
