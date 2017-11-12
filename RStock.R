
##A visualization practice of Stock in R using shiny
if (!require(quantmod)) {
  stop("This app requires the quantmod package. To install it, run 'install.packages(\"quantmod\")'.\n")
}


## use quantmod
library(shiny)
library(shinydashboard)
library(quantmod)
library(TTR)
library(gridExtra)
library(grid)
library(DT)
library(rsconnect)
symbols <- stockSymbols()
symbols <- symbols[,1]

deployApp("/Users/chunyiwang/R project/RStockVisualizationWeb")




app <- shinyApp(ui, server)

runApp(app)




