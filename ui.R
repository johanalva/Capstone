library(shiny)


shinyUI(fluidPage(
  
  # App title.
  titlePanel("Word Prediction Application"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("obs", "Please enter the text here"),
      
      submitButton("Predict")
    ),
    
    mainPanel(
      h6("Your text is:"),
      textOutput("Original"),
      br(),
      h6("Your text cleaned for better data modeling and prediction will be"),
      textOutput("Translated"),
      br(),
      br(),
      h3("Prediction"),
      div(textOutput("BestGuess"), style = "color:blue"),
      br(),
      h3("Based on training text, other words could be:"),
      tableOutput("view")
    )
  )
))


rsconnect::setAccountInfo(name='johnalva',
                         token='C9A11F8D139F4B086FB885E18AD5CACD',
                         secret='GNh6D6K0r+cdKSaKjDehpljHCwpHj8rS++sl+X8d')

rsconnect::deployApp("C:/Users/johnalva/Box Sync/My Documents/R/Cap/CapstoneFinal/Capstone")

