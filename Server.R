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
                theme=chartTheme(input$Color),
                TA = TAInput())
    zoomChart(paste(input$Range, collapse = "::"))
  })
  output$PreformancePlot <- renderPlot({
    charts.PerformanceSummary(get(getSymbols(input$Name)), main="Performance Summary",
                              geometric=FALSE, wealth.index=TRUE)
  })
  
  TAInput <- reactive({
    indicatorslist <- c(input$ta_vol, input$ta_sma, input$ta_ema, 
                      input$ta_wma,input$ta_bb, input$ta_momentum)
    addIndicators <- c(addVo(), addSMA(), addEMA(), addWMA(), 
               addBBands(), addMomentum())
    if (any(indicatorslist)) addIndicators[indicatorslist]
    else "NULL"
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
