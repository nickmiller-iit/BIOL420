
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

selection <- function (p.init, w.AA, w.Aa, w.aa, generations){
  freqs <- vector (mode = 'double', length = generations)
  freqs[1] <- p.init
  for (g in 1 : (generations - 1)){
    numerator <- w.AA * (freqs[g]^2)
    numerator <- numerator + (w.Aa * freqs[g] * (1 - freqs[g]))
    w.bar <- w.AA * (freqs[g]^2)
    w.bar <- w.bar + (w.Aa * 2 * freqs[g] * (1 - freqs[g]))
    w.bar <- w.bar + w.aa * ((1 - freqs[g])^2)
    freqs[g + 1] <- numerator / w.bar
  }
  return (freqs)
}


shinyServer(function(input, output) {

  output$freqPlot <- renderPlot({
    
    plot(1:input$gens,
         selection(
           0.01,
           input$w.AA,
           input$w.Aa,
           input$w.aa,
           input$gens
         ),
         ylim = c(0,1),
         ylab = "p",
         xlab = "generation",
         type = "l",lwd = 2)

#     # generate bins based on input$bins from ui.R
#     x    <- faithful[, 2]
#     bins <- seq(min(x), max(x), length.out = input$bins + 1)
# 
#     # draw the histogram with the specified number of bins
#     hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
