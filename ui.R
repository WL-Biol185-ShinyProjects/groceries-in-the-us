library(shiny)

fluidPage(
  
  titlePanel("outputstates.csv"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId  = "state",
        label    = "Select a State:",
        choices  = sort(unique(outputstates$State)),
        selected = "California"
      )
    ),
    
    mainPanel(
      plotOutput("BarByState")
    )
  )
)