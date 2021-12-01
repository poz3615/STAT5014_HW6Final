library("shiny")

shinyUI(pageWithSidebar(
  
  headerPanel("INVESTMENTS"),
  
  sidebarPanel(
    selectInput("symbol", "Stock", 
                choices = c("AAPL","MRNA","NKE","CMG"), selected = c("AAPL","MRNA","NKE","CMG"),
                multiple = TRUE), 
    
    dateRangeInput('dateRange',
                   label = 'Date of Stock: yyyy-mm-dd',
                   start = '2021-11-01', end = Sys.Date()),
    
    conditionalPanel(
      condition = "input.symbol.indexOf('AAPL') > -1",
      numericInput("var1","Investment AAPL","0")
    ),
    
    conditionalPanel(
      condition = "input.symbol.indexOf('MRNA') > -1",
      numericInput("var2","Investment MRNA","0")
    ),
    
    conditionalPanel(
      condition = "input.symbol.indexOf('NKE') > -1",
      numericInput("var3","Investment NKE","0")
    ),
    
     
    conditionalPanel(
      condition = "input.symbol.indexOf('CMG') > -1",
      numericInput("var4","Investment CMG","0")
    ),
   
  mainPanel(
    
    tabsetPanel(
      tabPanel(
        "Portfolio",
        plotOutput("portfolio")),
      
      tabPanel(
        "Timeseries",
        plotOutput("timeseries")
      )
      
      
    )
  )
  
)
)
