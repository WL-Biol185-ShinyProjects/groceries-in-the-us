library(shinydashboard)
library(shiny)
outputstates <- read.csv("outputstates.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dollars spent by state per category", tabName = "BarByState"),
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
                )
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
        )
      )
    )
  )
