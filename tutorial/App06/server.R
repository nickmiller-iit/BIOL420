# server.R

library(quantmod)
source("helpers.R")

shinyServer(function(input, output) {
    
    dataInput <- reactive({
        getSymbols(input$symb,
                   src = 'yahoo',
                   from = input$dates[1],
                   to = input$dates[2],
                   auto.assign = F)
    })
    
    finalInput <- reactive({
        if (input$adjust == F) return(dataInput())
        adjust(dataInput())
    })
    
    
    
    
    output$plot <- renderPlot({
#     data <- getSymbols(input$symb, src = "yahoo", 
#       from = input$dates[1],
#       to = input$dates[2],
#       auto.assign = FALSE)
                 
    chartSeries(finalInput(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })
  
})