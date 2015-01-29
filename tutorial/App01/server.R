library(shiny)

#define server logic to draw a histogram
shinyServer(function(input, output) {
  output$distPlot <- renderPlot({
      x <- faithful[, 2] #old faithful data
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      hist(x, breaks = bins, col = 'darkgray', border='white')
  })  
    
})