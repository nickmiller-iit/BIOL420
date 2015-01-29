pageTitle <- titlePanel('census visualization')

sidePanelText <- "Create demographic maps from the 2010 census"

selector <- selectInput('select',
                        'choose a variable to display',
                        choices = list('Percent White' = 1,
                                       'Percent Black' = 2,
                                       'Percent Hispanic' = 3,
                                       'Percent Asian' = 4)
                        )
slider <- sliderInput('range',
                      'range of interest',
                      min = 0,
                      max = 100,
                      value = c(0, 100))

sidebar <- sidebarPanel(sidePanelText, selector, slider)

page <- fluidPage(pageTitle, sidebar)