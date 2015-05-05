# Marbles in a bag simulation

library(shiny)
library(grImport)
library(lattice)


# Determine figure dimensions. Goal is to be as close to square as we
# can be.
fig_dimensions <- function(x){
  x <- as.integer(x)
  cols <- ceiling(sqrt(x))
  rows <- ceiling(x / cols)
  c(cols, rows)
}

# Draw a figure representing a set of marbles. Will produce a roughly
# square grid. Set is represented as a logical vector. TRUE represents
# red marbles, FALSE represents blue marbles
draw_fig <- function(marbles){
  n <- length(marbles)
  dims <- fig_dimensions(n)
  cols <- dims[1]
  rows <- dims[2]
  x <- rep(1:cols, times = rows)
  y <- rep(1:rows, each = cols)
  x <- x[1:n]
  y <- y[1:n]
  # Size to draw the mables determined empirically / by guesswork
  # To Do: figure out a function that calculates the size
  sz <- 0.35 / cols
  #produce the figure
  plot(x = NULL,
       y = NULL,
       type = "n",
       xlim = c(0, cols + 1),
       ylim = c(rows + 1, 0),
       xlab = "",
       ylab = "",
       xaxt = "n",
       yaxt = "n")
  xx <- grconvertX(x = x, from = 'user', to = 'ndc')
  yy <- grconvertY(y = y, from = 'user', to = 'ndc')
  grid.symbols(red, x = xx[marbles], y = yy[marbles], size = sz)
  grid.symbols(blue, x = xx[!marbles], y = yy[!marbles], size = sz)
  
}

#load images of red and blue marbles
red <- readPicture("red.eps.xml")
blue <- readPicture("blue.eps.xml")

# Represent our bag of 1000 marbles
bag <- c(rep("red", 600), rep('blue', 400))



shinyServer(function(input, output) {

    output$fig <- renderPlot({

    # Does nothing excet force re-evaluation without changing the slider
    input$sample
    # Generate our sample of marbles
    marbles <- sample(bag, input$n) == "red"
    
    
    draw_fig(marbles)
    

  })#end renderplot

})
