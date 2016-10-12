library(shiny)
library(dygraphs)

shinyUI(fluidPage(
    ## change titles
  titlePanel("Carry Trade Profit"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select Starting and Destination Cities"),

      ## how do we want to handle the choices -- just allow for certain choices? ------
      selectizeInput("starting", label = h3("Select Starting City"), choices= c("JPY" = "1", "GBP" = "2"), selected = "JPY") ,
      
      selectizeInput("destination", label = h3("Select Destination City"), choices= c("JPY" = "1", "GBP" = "2"), selected = "GBP")
      
      ## dateRangeInput("dates", "Date Range", start = "2000-01-01", end = Sys.Date())      
      
## TODO: Input a date range input so you can specify the carry trade interval ----
    ),
    
    ### uncomment for static chart    
    ## mainPanel(plotOutput("plot"))
    
    ### uncomment for dygraphs chart
    mainPanel(dygraphOutput("plot"))
  )
))
