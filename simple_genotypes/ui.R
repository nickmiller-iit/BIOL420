
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(


  titlePanel("Sampling genotypes"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      actionButton("sample", "Next Population")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p("This application simulates the genotypes of 100 inviduals for
         a diallelic locus. Click the button on the left to draw an new
         sample from a different locus"),
      tableOutput("geno_table")
    )
  )
))
