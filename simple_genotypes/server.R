library(shiny)

shinyServer(function(input, output) {

  output$geno_table <- renderTable({

    input$sample #does nothing except trigger an update
    n = 100
    p <- runif(1, min = 0.25, max = 0.75)
    q <- 1 - p
    counts <- rmultinom(1, size = n, prob = c(p^2, 2 * p * q, q^2))
    counts <- matrix(counts, 
                     nrow = 1, 
                     dimnames = list("count", c("AA", "Aa", "aa")))
  })

})
