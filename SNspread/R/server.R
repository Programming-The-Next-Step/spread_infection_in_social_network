library(shiny)

# Make social network and plot
shinyServer(function(input, output) {

  # Save SN_matrix for use in simulation spread
  global <- shiny::reactiveValues(SN_matrix = SNspread::create_network(n = 10))

  # Save index for updating network
  index <- shiny::reactiveVal(0)

  output$SNplot <- shiny::renderPlot({

    # Output new network when user in creating the network
    if (input$Usage == "Create Network") {

      # Generate a social network
      SN <- SNspread::create_network(n = input$frnds)
      index(0)

      # Save matrix
      global$SN_matrix <- SN

      # Create graph of social network
      SNspread::create_graph(weight_matrix = SN)

    } else if (input$Usage == "Update Network"){
      if (length(input$gender1) == 0) {

        SNspread::create_graph(weight_matrix = global$SN_matrix)

      } else {

        input$submit_gender # only update when button is clicked

        isolate({

          # Update gender & name
          gender_vector <- global$SN_matrix[, "gender"]
          gender_vector[index()] <- input$gender1

          name_vector <- rownames(global$SN_matrix)
          if (input$frndsnames != "") {
            name_vector[index() - 1] <- input$frndsnames
          }

          # Update network
          SN <- SNspread::update_network(weight_matrix = global$SN_matrix,
                                         gender = gender_vector,
                                         names = name_vector)
          # Save matrix
          global$SN_matrix <- SN

        })

        # Create graph of social network
        SNspread::create_graph(global$SN_matrix)

      }

    } else if (input$Usage == "Simulate Spread") {
      # Output infected network when user is simulating spread

      input$submit

      # Infect network
      SN <- isolate(SNspread::sim_spread(weight_matrix = global$SN_matrix,
                                        spread_rate = input$spr_rate))

      # Save matrix
      global$SN_matrix <- SN

      # Create graph of infected social network
      SNspread::create_graph(weight_matrix = SN)

    }
  })

  output$sliders <- shiny::renderUI({

    if (input$Usage == "Update Network"){

      input$submit_gender

      # TODO If statement that only allows to do this for number of friends
      isolate({

        if (index() == (input$frnds + 1)) {
          index(1)
        } else {
          new_index <- index() + 1
          index(new_index)
        }

        list(sliderInput("gender1",
                         paste("Please input gender of ",
                               rownames(global$SN_matrix)[index()],
                               " (1 = man, 2 = woman):", sep = ""),
                         min = 1,
                         max = 2,
                         value = 0,
                         step = 1),
             textInput("frndsnames",
                       paste("Please input name of ",
                             rownames(global$SN_matrix)[index()],
                             " and click on submit:", sep = "")))
      })
    }
  })
})
