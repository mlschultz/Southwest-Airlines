library(ggmap)
library(dygraphs)

shinyServer(function(input, output) {
  
  dataInput <- reactive({
    
    fxFundingSym <- switch(input$funding, 
                           "1" = "EXJPUS",
                           "2" = "EXUSUK")
    
    fxInvestingSym <- switch(input$investing,
                             "1" = "EXJPUS",
                             "2" = "EXUSUK")
    
    ## Interest Rates, Government Securities, Treasury Bills for Japan:    INTGSTJPM193N
    
    ## Interest Rates, Government Securities, Treasury Bills for United Kingdom:  INTGSTGBM193N
    
    IfundingSym <- switch(input$funding,
                          "1" = "INTGSTJPM193N",
                          "2" = "INTGSTGBM193N")
    
    IinvestingSym <- switch(input$investing,
                            "1" = "INTGSTJPM193N",
                            "2" = "INTGSTGBM193N")
    
    Cfunding <- getSymbols(fxFundingSym, auto.assign = FALSE, src = "FRED")
    Cinvesting <- getSymbols(fxInvestingSym, auto.assign = FALSE, src = "FRED")
    Ifunding <- getSymbols(IfundingSym, auto.assign = FALSE, src = "FRED")
    Iinvesting <- getSymbols(IinvestingSym, auto.assign = FALSE, src = "FRED")
    
    allData <- merge.xts(Cfunding, Cinvesting, Ifunding, Iinvesting, join = "inner")
    allData <- allData[complete.cases(allData),]
    names(allData) <- c("Cfunding", "Cinvesting", "Ifunding", "Iinvesting")
        allData <- allData[paste(input$dates[1],"/",input$dates[2], sep = "")]
        
    
    ## cross rate is JPY/GBP -- the amount of yen per GBP ----
    crossRate <- allData$Cfunding * allData$Cinvesting
    
    ## percent change in currencies
    perChangeGBP <- Delt(crossRate)[-1]
    perChangeJPY <- lag(crossRate)[-1]/crossRate[-length(crossRate)] - 1
    
    if(fxFundingSym == "EXJPUS") {
      FXret <- cumsum(perChangeGBP)
      Iret <- cumsum((allData$Iinvesting[-1] - allData$Ifunding[-1])/12)
      totRet <- FXret * 100 + Iret
      
    } else {
      FXret <- cumsum(perChangeGBP)
      Iret <- cumsum((allData$Iinvesting[-1] - allData$Ifunding[-1])/12)
      totRet <- -FXret * 100 + Iret
      
    }
    totRet <<- totRet
  })
  
  output$plot <- renderDygraph({
    
    #    allData1 <- dataInput()
    
        dygraph(dataInput()) %>%  ## you can use 'main = ' and 'ylab =' and so forth here to set the charts title, yaxis, and so on
      dyRangeSelector()
  })
})
