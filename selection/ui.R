
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Selection"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("w.AA",
                  "Fitness of AA",
                  min = 0,
                  max = 1,
                  value = 1,
                  step = 0.05),
      numericInput("w.Aa",
                  "Fitness of Aa",
                  min = 0,
                  max = 1,
                  value = 1,
                  step = 0.05),
      numericInput("w.aa",
                  "Fitness of aa",
                  min = 0,
                  max = 1,
                  value = 0.5,
                  step = 0.05),
      numericInput("gens",
                   "Generations",
                   min = 50,
                   max = 5000,
                   value = 100,
                   step = 50)
    ),
    

    # Show a plot of the generated distribution
    mainPanel(
      p("This application allows you to simulate changing allele frequencies
         as a result of natural selection at a locus with 2 alleles", em("A"),
        " and", em("a."), "use the controllers on the left to change the relative
         fitnesses of the three genotypes."),
      p(strong("Important"), "The fitness of the most fit genotype (or
         genotypes) should always be equal to 1"),
      plotOutput("freqPlot")
    )
  )
))
