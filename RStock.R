

```{r}
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
symbols <- stockSymbols()
symbols <- symbols[,1]



choices <-
  c(
    "Market Cap","Enterprise Value",
    "Trailing P/E"
  )

indicators <-
  c(
    "Bollinger Bands",
    "Weighted Moving Average",
    "Commodity Channel Index"
  )

#get data
if (interactive()) {
  options(device.ask.default = FALSE)
  ui <- dashboardPage(
    dashboardHeader(title = "Stock Data dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem(
          "Stock",
          tabName = "Stock"
        )
      )),
    dashboardBody(
      titlePanel("Visualize Stock Data"),
      sidebarLayout(
        sidebarPanel(
          dateRangeInput("Range", "Choose Date Range:", start=Sys.Date() - 365,
                         end= Sys.Date(), format = "yyyy-mm-dd"),
          selectizeInput('Name', label= 'Choose a stock', symbols, selected = NULL, multiple = FALSE,
                         options = NULL),
          selectInput("Color", label = "Select Color", choices = c("white","black")),
          checkboxGroupInput("quickstats", "Key Statistics:",
                             choices),
          checkboxGroupInput("indicators", "Key Indicators:",
                             indicators),
          selectInput("PlotType", label = "Plot type", choices = c("candlesticks", "matchsticks", "bars", "line")),
          submitButton("Submit")
        ),
        
        mainPanel(
          tabsetPanel(type="tab",tabPanel("Plot",plotOutput("Plot")),
                      tabPanel("Statistics",tableOutput("Stat")),
                      tabPanel("Return",
                               selectInput("ReturnType", label = "Select Return Type", choices = c("yearly",'quarterly',"monthly", "daily")),
                               submitButton("Apply"),
                               DT::dataTableOutput("Return")))
          
        )
      )
    )
  )
  server <- function(input, output) {
    output$Plot <- renderPlot({
      chartSeries(get(getSymbols(input$Name)), type = input$PlotType, 
                  theme=chartTheme(input$Color), name=paste(start, end,sep = " "), TA="addBBands();addEMA()")
      zoomChart(paste(input$Range, collapse = "::"))
    })
    output$Return <- DT:: renderDataTable({
      DT::datatable(
        data.frame( a <- periodReturn(get(getSymbols(input$Name)),period=input$ReturnType,from='2007-01-01',to='2011-01-01')
                    
        )
        
        
      )
    })
    observe({
      print(input$Range)
      print(input$Name)
      print(input$Tools)
      print(periodReturn(get(getSymbols(input$Name)),by=years,from='2003-01-01',to='2004-01-01'))
    })
  }
  shinyApp(ui, server)
}




```