library(shiny)
library(shinydashboard)
library(quantmod)
library(TTR)
library(gridExtra)
library(grid)
library(DT)
library(rsconnect)
function(input, output) {
  output$Plot <- renderPlot({
    chartSeries(get(getSymbols(input$Name)), type = input$PlotType, 
                name=input$Name,
                theme=chartTheme(input$Color))
    zoomChart(paste(input$Range, collapse = "::"))
  })
  
  output$Return <- DT:: renderDataTable({
    DT::datatable(
      data.frame( a <- periodReturn(get(getSymbols(input$Name)),period=input$ReturnType,from='2007-01-01',to='2011-01-01')
      )
    )
  })
  
  observe({
    print(input$Name)
    print(input$Tools)
  })
}
