## use quantmod
library(shiny)
library(shinydashboard)
library(PerformanceAnalytics)
library(quantmod)
library(TTR)
library(gridExtra)
library(grid)
library(DT)
library(rsconnect)
symbols <- stockSymbols()
symbols <- symbols[,1]

dashboardPage(
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
        
    
        selectInput("PlotType", label = "Plot type", choices = c("candlesticks", "matchsticks", "bars", "line")),
        

        ## get idea from https://gist.github.com/garrettgman/6511225
        checkboxInput("ta_vol", label = "Volume", value = FALSE),
        checkboxInput("ta_sma", label = "Simple Moving Average", 
                      value = FALSE),
        checkboxInput("ta_ema", label = "Exponential Moving Average", 
                      value = FALSE),
        checkboxInput("ta_wma", label = "Weighted Moving Average", 
                      value = FALSE),
        checkboxInput("ta_bb", label = "Bolinger Bands", 
                      value = FALSE),
        checkboxInput("ta_momentum", label = "Momentum", 
                      value = FALSE),
        
        
        submitButton("Submit")
      ),
      
      mainPanel(
        tabsetPanel(type="tab",tabPanel("Plot",plotOutput("Plot")),
                    tabPanel("Performance Plot",plotOutput("PreformancePlot")),
                    tabPanel("Return",
                             selectInput("ReturnType", label = "Select Return Type", choices = c("yearly",'quarterly',"monthly", "daily")),
                             submitButton("Apply"),
                             br(),
                             DT::dataTableOutput("Return")))
        
      )
    )
  )
)
