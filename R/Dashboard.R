library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
  
  githubURL<-("C:/Users/Piper Zimmerman/Downloads/Stocks.RDS")
  data<-readRDS(githubURL)
  
  Investment<-reactive({
    
    Investment<-data.frame(symbol=character(),weights=numeric())
    
    if(!is.null(input$var1)){
      Investment<-Investment%>%add_row(symbol='AAPL',weights=input$var1)
    }
    if(!is.null(input$var2)){
      Investment<-Investment%>%add_row(symbol='MRNA',weights=input$var2)
    }
    if(!is.null(input$var3)){
      Investment<-Investment%>%add_row(symbol='NKE',weights=input$var3)
    }
    if(!is.null(input$var4)){
      Investment<-Investment%>%add_row(symbol='CMG',weights=input$var4)
    }
    Investment$weights<-Investment$weights/sum(Investment$weights)
    return(Investment)
  })
  
  reactive_data <- reactive({
    data %>%
      filter(symbol %in% input$symbol) %>%
      filter(date >= input$dateRange[1] & date<= input$dateRange[2]) %>%
      left_join(Investment(),by = "symbol")
  }) 
  
  
  output$timeseries <- renderPlot({
    
    ggplot(reactive_data(),aes(x=date,y=adjusted,color=symbol))+
      geom_point()+geom_line()+xlab('Date')+ylab('Adjusted price')+theme_bw()+
      ggtitle("Plot of Adjusted price")
    
  })
  
  
 
  
  output$portfolio <- renderPlot({
    
    portfoliodata<-reactive_data()%>%
      mutate(returns=adjusted/lag(adjusted,1)-1) %>%
      mutate(weighted.returns=returns*weights) %>%
      filter(date>min(date))
    
    ggplot(portfoliodata,aes(x=date,y=weighted.returns,fill=symbol))+
      geom_bar(stat='identity')
  })
  
})
