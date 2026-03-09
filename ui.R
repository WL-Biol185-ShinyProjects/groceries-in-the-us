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
    menuItem("Recipe Generator", tabName = "Recipes"),
    menuItem("How Expensive Are My Groceries?", tabName = "UnitPricePerState")
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
      .top3-card {
        background: white;
        border: 2px solid #f4a261;
        border-radius: 14px;
        padding: 18px 14px;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s ease;
        height: 130px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }
      .top3-card:hover {
        background-color: #fff0e0;
        border-color: #e76f51;
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(231,111,81,0.2);
      }
      .top3-card.selected {
        background-color: #e76f51;
        border-color: #c0392b;
        color: white;
      }
      .top3-card.selected .card-rank {
        color: #ffe0d0;
      }
      .top3-card.selected .card-dollars {
        color: #ffe0d0;
      }
      .card-rank {
        font-size: 11px;
        color: #aaa;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 4px;
      }
      .card-category {
        font-size: 17px;
        font-weight: bold;
        color: #e76f51;
        margin-bottom: 4px;
      }
      .top3-card.selected .card-category {
        color: white;
      }
      .card-dollars {
        font-size: 12px;
        color: #888;
      }

      /* ── Explore section ── */
      .explore-header {
        font-size: 18px;
        font-weight: bold;
        color: #e76f51;
        margin: 24px 0 10px 0;
        border-top: 2px dashed #f4a261;
        padding-top: 18px;
      }
      .explore-btn {
        background-color: white !important;
        border: 2px solid #f4a261 !important;
        color: #e76f51 !important;
        border-radius: 8px !important;
        margin: 4px !important;
        font-size: 13px !important;
      }
      .explore-btn:hover {
        background-color: #fff0e0 !important;
      }
      .explore-btn.active-explore {
        background-color: #f4a261 !important;
        color: white !important;
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
                  # ── Left panel: state picker ──
                  column(3,
                         wellPanel(
                           style = "background-color:#fff8f0; border: 2px solid #f4a261; border-radius: 12px;",
                           h4("Your State", style = "color:#e76f51;"),
                           selectInput("recipe_state", NULL,
                                       choices  = sort(unique(outputstates$State)),
                                       selected = "California"),
                           hr(style = "border-color:#f4a261;"),
                           p(style = "font-size:13px; color:#888;",
                             "We'll find the top 3 grocery categories in your state and suggest a recipe for each one.")
                         )
                  ),
                  
                  # ── Middle: top-3 cards + explore ──
                  column(9,
                         h4("Top 3 Categories in Your State", style = "color:#e76f51; margin-top:6px;"),
                         p(style = "font-size:13px; color:#888; margin-bottom:14px;",
                           "Click a category card to see a recipe inspired by what your state buys most."),
                         
                         # The 3 clickable cards are rendered server-side
                         uiOutput("top3Cards"),
                         
                         # ── Explore other recipes ──
                         div(class = "explore-header",
                             "🔍 Explore Other Recipes"),
                         p(style = "font-size:13px; color:#888; margin-bottom:10px;",
                           "Want to try something different? Pick any category below."),
                         uiOutput("exploreButtons"),
                         
                         br(),
                         
                         # Recipe output area
                         uiOutput("recipeOutput")
                  )
                )
              )
      ),
    

      tabItem(tabName = "SalesDuringCovid",
              fluidPage(
                
                titlePanel("The COVID Pantry — Before/After Explorer"),
                
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
              ),
      tabItem(tabName = "UnitPricePerState",
              fluidPage(
                titlePanel("Click Each State to Discover the Average Cost of One Unit Per Category"),
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
    ),
      )
  )
  )
)