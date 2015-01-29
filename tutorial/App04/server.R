library(shiny)

foo <- function(input, output){
    output$text1 <- renderText({
        paste("You have selected", input$select)
    })
}

shinyServer(foo)