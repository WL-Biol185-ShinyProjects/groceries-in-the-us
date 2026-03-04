library(shinydashboard)
library(shiny)
outputstates <- read.csv("outputstates.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(
      
  menuItem("About the project", tabName = "IntroPage"),  
    menuItem("Dollars spent by state per category", tabName = "BarByState"),
      menuItem("The Covid Pantry", tabName = "SalesDuringCovid")
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "IntroPage",
              h2("About the project"),
                p("hello")
              ),
      tabItem(tabName = "BarByState",
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
                    plotOutput("BarByState")
                  )
                ),
                p("Choose a state to view a bar graph displaying the total amount 
                  of money spent per grocery category over time. Select multiple
                  states and see how these trends vary geographically.")
              )    
             ),
      tabItem(tabName = "SalesDuringCovid",
              fluidPage(
                
                titlePanel("🧺 The COVID Pantry — Before/After Explorer"),
                
                sidebarLayout(
                  sidebarPanel(
                    
                    selectInput(
                      inputId  = "state",
                      label    = "Select a State:",
                      choices  = sort(unique(outputstates$State)),
                      selected = "California"
                    ),
                    
                    selectInput(
                      inputId  = "category",
                      label    = "Select a Category:",
                      choices  = sort(unique(outputstates$Category)),
                      selected = "Alcohol"
                    ),
                    
                    sliderInput(
                      inputId = "covid_marker",
                      label   = "📍 Drag the COVID Marker:",
                      min     = as.Date("2019-10-06"),
                      max     = as.Date("2023-05-07"),
                      value   = as.Date("2020-03-15"),   # lockdown start
                      step    = 7,                        # weekly steps
                      timeFormat = "%b %d, %Y",
                      animate = FALSE
                    ),
                    
                    hr(),
                    
                    helpText("Drag the marker to explore how sales changed around COVID lockdowns. 
                March 15, 2020 marks the start of widespread US lockdowns.")
                    
                  ),
                  
                  mainPanel(
                    plotOutput("CovidPantry", height = "500px"),
                    br(),
                    uiOutput("summaryBox")
                  )
                )
              )
              )
    )
  )
)