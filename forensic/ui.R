
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  titlePanel("Simulated forensic DNA profiles"),

  # Sidebar with checkboxws to toggle loci and a button to force re-evaluation
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "chosenLoci",
        label = "Select loci to include",
        choices = c("D3S1358",
                    "TH01",
                    "D5S818",
                    "D13S317",
                    "D7S820",
                    "D16S539",
                    "VWA",
                    "D8S1179",
                    "TPOX"),
        selected = "D3S1358"
      ),
      actionButton(inputId = "next_sim",
                   label = "Next")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p("This application generates simulated genotypes at on or more of
         nine of the commonly used Simple Tandem Repeat loci used for
         forensic profiling of human DNA."),
      p("Use the checkboxes on the left to choose the loci to include
         in your simulated DNA profile."),
      tableOutput(outputId = "genotype")
    )
  )
))
