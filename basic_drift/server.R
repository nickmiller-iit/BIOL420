library(shiny)

#simulate drift in a single locus / population
drift_single <- function(start_p, N, duration){
  #intiate a vector to store p at each generation
  p <- double(length = duration)
  p[1] <- start_p
  for (i in 2:duration){
    p[i] <- rbinom(n = 1, size = N, prob = p[i-1]) / N
  }
  p
}

# Make a plot of p over time for a set of simulations. Simulations are
# represented as a matix, rows are generations, columns are individual
# simulations
plot_drift <- function(simulations){
  
  # how many simulations?
  num <- length(simulations[1,])
  
  # how many generations?
  duration <- length(simulations[,1])
  
  # set up colours
  cols <- rainbow(num)
  #store frequencies in a matrix, each column is one population/locus

  #set up blank plot
  plot(x = NULL, 
       y = NULL, 
       xlim = c(1, duration), 
       ylim = c(0, 1), 
       type = "n", 
       xlab = "generation", 
       ylab = "frequency")
  for (i in 1:num){
    lines(x = 1:duration, 
          y = simulations[,i], 
          col = cols[i],
          lwd = 2)
  }


}

#assume diploid, could be changed to read from input if needed
ploidy <- 2

shinyServer(function(input, output) {
  
  # After some head scratching, it looks like the values returned by
  # a reactive() don't change unless the input changes - the result
  # appears to be cached.
  
  simulations <- reactive({
    #trigger re-execution if the button is clicked
    input$next_sim
    
    N <- input$N * ploidy    
    replicate(input$pops, 
              drift_single(input$p, N, input$g), 
              simplify = "matrix")
  })
  
  output$drift_plot <- renderPlot({
      
    plot_drift(simulations())
    
  })
  
  output$final_p <- renderTable({
    finals <- simulations()[length(simulations()[,1]), ]
    data.frame(population = 1:length(finals), frequency = finals)
  })

})
