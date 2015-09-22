
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("./coalesce.R")

shinyServer(function(input, output) {

  output$treePlot <- renderPlot({
    #use action buttin to force new
    input$next_sim
    coal <- sim.coal(two.N = input$N * 2,
                     k = input$lineages)
    draw.tree(coal)

  })

})
