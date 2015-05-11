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
                   value = 20,
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
      p("This application simulates the change in frequency of an
         allele over time due to genetic drift.
         The simulation assumes a diploid organism.
         Use the controls to the left to change the starting allele
         frequency, the population size (number of individuals),
         the duration of the simulation (generations) and the number
         of replicate populations to simulate at the same time. Use
         the \"Next simulation\" buttonto run another simulation with 
         the same settings."),
      
      h3("Simulations"),
      
      plotOutput("drift_plot"),
      
      h3("Final allele frequencies"),
      
      tableOutput("final_p")
    )
  )
))
