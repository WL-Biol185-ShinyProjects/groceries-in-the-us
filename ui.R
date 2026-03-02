library(shinydashboard)
library(shiny)
outputstates <- read.csv("outputstates.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dollars spent by state per category", tabName = "BarByState")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Dollars spent by state per category",
              fluidPage(
                titlePanel("Dollars spent by state per category"),
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
                    plotOutput("Dollars spent per state per category")
                  )
                )
              )    
             )
    )
  )
)