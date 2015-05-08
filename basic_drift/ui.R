library(shiny)

shinyUI(fluidPage(

  titlePanel("Genetic Drift"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("p",
                  label = "Staring allele frequency",
                  min = 0,
                  max = 1,
                  value = 0.5),
      
      numericInput("N",
                   label = "Population size",
                   min = 10,
                   max = 1000000,
                   value = 50,
                   step = 10),
      
      numericInput("g",
                   "Number of generations",
                   min = 10,
                   max = 1000000,
                   value = 50,
                   step = 10),
      
      sliderInput("pops",
                  label = "Number of populations",
                  min = 1,
                  max = 10,
                  value = 6),
      
      actionButton("next_sim", "Next simulation")
    ),
    
    

    
    # Show a plot of the generated distribution
    mainPanel(
      p("Text"),
      
      plotOutput("drift_plot")
    )
  )
))
