shiny::shinyUI(
  dashboardPage(
    dashboardHeader(title = "Calculator"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("calculator")),
        menuItem("About", tabName = "abstract", icon = icon("info-circle")),
        menuItem("Model", tabName = "model", icon = icon("toolbox")),
        menuItem("Supplier", tabName = "supplier", icon = icon("tools"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
                shinyDashboardThemes(theme = "grey_light"),
                fluidPage(
                  shinyjs::useShinyjs(),
                  box(width = 6,
                      title = "Adjust the patient characteristics",
                      solidHeader = FALSE, status = "primary",
                      selectInput("SNstatus", "Positive or negative sentinel node status",
                                  choices = c("Negative", "Positive")),
                      sliderInput("age", "Enter the age at which the patient was diagnosed",
                                  20, 80, 55),
                      selectInput("ulceration", "Ulceration",
                                  choices = c("No", "Yes")),
                      selectInput("location", "Enter the location of the metastasis",
                                  choices = c("Arm", "Leg", "Trunk", "Head and neck")),
                      sliderInput("breslow", "Enter the Breslow thickness",
                                  min=0.1, max=7, value=0.1, step=0.1),
                      sliderInput("tumburden", "Select the level of tumour burden",
                                  0.01, 9, 1),
                      actionButton(inputId = "calculateButton", label = "Calculate", icon=icon("calculator"),
                                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                  ),
                  shinyjs::hidden(
                    div(
                      id="results.panel",
                      conditionalPanel(condition="calculateButton",
                                       box(width = 6,
                                           title = "Probability of",
                                           solidHeader = FALSE, status = "info",
                                           infoBoxOutput("recurrence_box", width = 12),
                                           infoBoxOutput("MSM_box", width = 12))),
                      conditionalPanel(condition="calculateButton",
                                       box(width = 12,
                                           title = "Disclaimer",
                                           solidHeader = FALSE, status = "warning",
                                           includeHTML("html/disclaimer.html")))
                    )
                  )
                )
        ),
        tabItem(tabName = "abstract",
                h2("Abstract"),
                includeHTML("html/abstract.html")),
        tabItem(tabName = "model",
                h2("Model"),
                includeHTML("html/model.html")),
        tabItem(tabName = "supplier",
                includeHTML("html/supplier.html"))
      )
    )
  )
)
