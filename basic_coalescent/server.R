
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(coalesceR)

shinyServer(function(input, output) {

  output$treePlot <- renderPlot({
    #use action buttin to force new
    input$next_sim
    tree <- sim.tree(method = "generations",
                     sample = input$lineages,
                     current = input$N,
                     ancestral = input$N,
                     time = 1)
    draw.tree(tree,
              labels = F)
  })

})
