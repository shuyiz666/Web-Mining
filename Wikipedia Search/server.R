# server.R
library(shiny)
library(tm)
library(stringi)
library(proxy)
source("WikiSearch.R")

shinyServer(function(input, output){
  output$cloudPlot <- renderPlot({
    # Progress Bar while executing function
    withProgress({
      setProgress(message = "Mining Wikipedia...")
      result <- SearchWiki(input$select)
    })
    result
  })
})
