# Define user interface
shiny::shinyUI(shiny::pageWithSidebar(

  # Page title
  shiny::headerPanel("Spread of infection in Social Network"),

  # Sidebare with slider that user can change
  shiny::sidebarPanel(
    shiny::selectInput("Usage",
                "Please select what you want to do:",
                choices = c("Create Network", "Update Network", "Simulate Spread")),
    shiny::conditionalPanel(condition = "input.Usage == 'Create Network'",
                            shiny::sliderInput("frnds",
                                               "Please input number of friends:",
                                               min = 1,
                                               max = 50,
                                               value = 10,
                                               step = 1)),
    shiny::conditionalPanel(condition = "input.Usage == 'Update Network'",
                            shiny::actionButton("submit_gender", "Submit")),
    shiny:: conditionalPanel(condition = "input.Usage == 'Simulate Spread'",
                             shiny::numericInput("spr_rate",
                                                 "Please input spread of infection:",
                                                 min = 1,
                                                 max = 10,
                                                 value = 2,
                                                 step = 1),
                             shiny::actionButton("submit", "Simulate"))
    ),

  # Show graph
  shiny::mainPanel(
    shiny::plotOutput("SNplot"),
    shiny::uiOutput("sliders")
  )
))
