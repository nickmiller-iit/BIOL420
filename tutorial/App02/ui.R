library(shiny)

t <- titlePanel('this is the title')

sp <- sidebarPanel('sidebar panel')

m <- mainPanel(h1('main panel'),
               p('This is a main panel, there are many like it, but this one is mine'),
               div("using the div() funtion to make a block of coloured text 
                   including ", em('italicized'), ' text', style = 'color:red')
                  )



sb <- sidebarLayout(sp, m)

page <- fluidPage(t, sb)

shinyUI(page)