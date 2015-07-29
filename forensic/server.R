
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

#read the allele frequencies in from file
freq.table <- read.table("allele.freqs", 
                         header = T, 
                         colClasses = c("factor", "factor", "numeric"))

#sample a single allele at a single locus
sampleAllele <- function(dataTable, loc){
  tab <- subset(dataTable, locus == loc)
  sample(as.character(tab$allele), size = 1, prob = tab$freq)
}

#sample a diploid genotype at a single loci
sampleGenotype <- function(dataTable, loc){
  a1 <- sampleAllele(dataTable, loc)
  a2 <- sampleAllele(dataTable, loc)
  cbind(loc, a1, a2)
}

#sample a multilocus genotype
sampleMultiGenotype <- function(dataTable, loci){
  geno <- data.frame(sampleGenotype(freq.table, loci[1]))
  for (l in loci[-1]) {
    geno <- rbind(geno, sampleGenotype(freq.table, l))
  }
  names(geno) <- c("Locus", "Allele1", "Allele2")
  geno
  
}


shinyServer(function(input, output) {
  
#   simulatedGeno <- reactive({
#     #force a new simulation using the action button
#     input$next_sim
#     sampleMultiGenotype(freq.table, input$chosenLoci)
#   })
  
  output$genotype <- renderTable({
    sampleMultiGenotype(freq.table, input$chosenLoci)
  })



})
