library(shiny)
library(maps)
library(mapproj)

counties <- readRDS('data/counties.rds')
source('helpers.R')



shinyServer(function(input, output){
    output$map <- renderPlot({
        
        data <- switch(input$select,
                       'Percent White' = counties$white,
                       'Percent Black' = counties$black,
                       'Percent Hispanic' = counties$hispanic,
                       'Percent Asian' = counties$asian
            )
        
        percent_map(var = data,
                    color = 'darkgreen',
                    legend.title = input$select,
                    max = max(input$range),
                    min = min(input$range))
    })
})