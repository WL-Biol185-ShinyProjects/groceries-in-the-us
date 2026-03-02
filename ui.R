library(shinydashboard)
library(shiny)

dashboardPage(
  dashboardHeader(Title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dollars spent by state per category", tabName = "BarByState")
    )
  ),
  dashboardBody(
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
  )
)