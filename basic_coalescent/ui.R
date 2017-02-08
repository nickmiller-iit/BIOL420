
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Coalescent simulations"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput(inputId = "N",
                   label = "Population size",
                   value = 50,
                   min = 20),
      sliderInput(inputId = "lineages",
                  label = "Number of lineages",
                  min = 2,
                  max = 20,
                  value = 2),
      actionButton(inputId = "next_sim",
                   label = "Next simulation")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p("This application peforms basic simulations of the coalescent 
        process. Use the controls on the left to change the population 
        size and number of lineages. Use the \"Next simulation\" button 
        to run additional simulations with the same values"),
      plotOutput("treePlot")
    )
  )
))
