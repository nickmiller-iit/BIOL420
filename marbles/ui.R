# Marbles in a bag simulation UI
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Marbles", windowTitle = "Marbles"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("n",
                  "Number of marbles to draw from the bag",
                  min = 1,
                  max = 50,
                  value = 6),
      # Action button used to force re-evaluation without changing slider
      actionButton("sample", label = "Sample")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p("This application simulates drawing a number of marbles from a bag.
         The bag contains a mix of red and blue marbles, and there are 1,000
         marbles in total. Use the slider to set the number of marbles
         to draw from the bag. Use the \"Sample\" button to draw another
         sample."),
      plotOutput("fig")
    )
  )
))
