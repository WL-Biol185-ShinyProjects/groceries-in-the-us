library(shinydashboard)
library(shiny)
outputstates <- read.csv("outputstates.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(

  menuItem("About the project", tabName = "IntroPage"),  
    menuItem("Dollars spent by state per category", tabName = "BarByState"),
    menuItem("The Covid Pantry", tabName = "SalesDuringCovid"),
    menuItem("Recipe Generator", tabName = "Recipes", icon = icon("utensils"))

    )
  ),
  dashboardBody(
      tags$head(tags$style(HTML("
      .recipe-box {
        background: linear-gradient(135deg, #fff9f0, #fff0e6);
        border-radius: 16px;
        padding: 24px;
        border: 2px solid #f4a261;
        font-family: Georgia, serif;
      }
      .recipe-title {
        font-size: 26px;
        font-weight: bold;
        color: #e76f51;
        margin-bottom: 8px;
      }
      .recipe-body {
        font-size: 15px;
        color: #333;
        line-height: 1.8;
        white-space: pre-wrap;
      }
      .state-badge {
        display: inline-block;
        background-color: #e76f51;
        color: white;
        border-radius: 20px;
        padding: 4px 14px;
        font-size: 13px;
        margin-bottom: 16px;
      }
      .generate-btn {
        background-color: #f4a261 !important;
        border-color: #e76f51 !important;
        color: white !important;
        font-size: 16px !important;
        border-radius: 10px !important;
        padding: 10px 24px !important;
      }
      .top-categories {
        background-color: #fdf4ec;
        border-radius: 10px;
        padding: 12px 16px;
        margin-bottom: 16px;
        font-size: 13px;
        color: #555;
      }
    "))),
    tabItems(
      tabItem(tabName = "IntroPage",
              h2("About the project"),
                p("Groceries in the US is a project that utilizes the USDA’s Weekly Retail Food Sales data set, which used data collected from checkout scanners in a representative sample of grocery stores. This data was sent to a research firm that aggregated all of the results and organized them by week. Collections began on October 6, 2019 and ended on May 7, 2023. You may notice as you explore the pages of our project that certain states are missing. This is because Alaska, Delaware, Hawaii, Idaho, Iowa, Kansas, Nebraska, New Jersey, North Dakota, Mississippi, Montana, and Washington D.C. because the research firm used by the USDA (Circana) does not collect state-level data in these locations. Additionally, you will notice that grocery items are grouped into various categories. To help understand what items count in each category, we have provided a table below that summarizes the types of product considered under each category as outlined by the USDA, and some potential examples of these products. ")
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
                    plotOutput("BarPlot")
                  )
                ),
                p("Choose a state to view a bar graph displaying the total amount 
                  of money spent per grocery category over time. Select multiple
                  states and see how these trends vary geographically.")
              )    
             ),

    tabItem(tabName = "Recipes",
            fluidPage(
              titlePanel("Dinner Recipe Generator"),
              br(),
              fluidRow(
                column(4,
                       wellPanel(
                         style = "background-color:#fff8f0; border: 2px solid #f4a261; border-radius: 12px;",
                         h4("Settings", style = "color:#e76f51;"),
                         selectInput("recipe_state", "Pick a State:",
                                     choices  = sort(unique(outputstates$State)),
                                     selected = "California"),
                         selectInput("recipe_category", "Pick a Category:",
                                     choices  = c("Fruits", "Vegetables", "Dairy", "Grains",
                                                  "Meats", "Beverages", "Fats and oils",
                                                  "Sugar and sweeteners", "Commercially prepared items",
                                                  "Other"),
                                     selected = "Meats"),
                         br(),
                         actionButton("generateRecipe", "Generate Recipe!",
                                      class = "generate-btn", width = "100%")
                       )
                ),
                column(8,
                       uiOutput("recipeOutput")
                )
              )
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