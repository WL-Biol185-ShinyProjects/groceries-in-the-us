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
    menuItem("How Expensive Are My Groceries?", tabName = "UnitPricePerState"),
    menuItem("Compare Cost of Each Item by State", tabName = "CategoryPricePerState")
    )
  ),
  dashboardBody(
      tags$head(includeCSS("aes.css")),
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
      ),
      tabItem(tabName = "CategoryPricePerState",
              fluidPage(
                titlePanel("Click each category to examine how unit prices vary by state"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "category",
                      label = "Select a Category:",
                      choices = sort(unique(outputstates$Category)),
                      selected = "Alcohol"
                    )
                  ),
                  mainPanel(
                    plotOutput("BarPlot")
                  )
                ),
              ),
              ),
  )
  )
)