library(shiny)

# Define user interface
shinyUI(pageWithSidebar(

  # Page title
  headerPanel("Spread of infection in Social Network"),

  # Sidebare with slider that user can change
  sidebarPanel(
    selectInput("Usage",
                "Please select what you want to do:",
                choices = c("Create Network", "Update Network", "Simulate Spread")),
    conditionalPanel(condition = "input.Usage == 'Create Network'",
                     sliderInput("frnds",
                                 "Please input number of friends:",
                                 min = 1,
                                 max = 50,
                                 value = 10,
                                 step = 1)),
    #conditionalPanel(condition = "input.Usage == 'Update Network'",
     #                sliderInput("gender1",
      #                           "Please input gender (1 = man, 2 = woman):",
       #                          min = 1,
        #                         max = 2,
         #                        value = 0,
          #                       step = 1)),
    conditionalPanel(condition = "input.Usage == 'Update Network'",
                     actionButton("submit_gender",
                                  "Submit")),
    conditionalPanel(condition = "input.Usage == 'Simulate Spread'",
                     numericInput("spr_rate",
                               "Please input spread of infection:",
                               min = 1,
                               max = 10,
                               value = 2,
                               step = 1),
                     actionButton("submit",
                                  "Simulate"))
    ),

  # Show graph
  mainPanel(
    plotOutput("SNplot"),
    uiOutput("sliders")
  )
))
