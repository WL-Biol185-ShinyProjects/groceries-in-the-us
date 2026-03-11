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
    menuItem("Compare Cost of Each Item by State", tabName = "CategoryPricePerState"),
    menuItem("Quiz Yourself", tabName = "Quiz")
    )
  ),
  dashboardBody(
      tags$head(includeCSS("aes.css")),
    tabItems(
      tabItem(tabName = "IntroPage",
              fluidPage(
                # ── Hero section ──
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 40px; margin-bottom: 24px;
               color: white; text-align: center;",
                  h1("Groceries in the US", style = "font-weight: 600; font-size: 36px;"),
                  p("Exploring American grocery spending patterns from 2019–2023",
                    style = "font-size: 16px; opacity: 0.9; margin-bottom: 0;")
                ),
                
                # ── About text ──
                div(
                  style = "background: white; border-radius: 16px; padding: 28px;
               box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 24px;",
                  h4("About the Project", style = "color: #e76f51; font-weight: 600;"),
                  p("This project utilizes the USDA's Weekly Retail Food Sales dataset, collected
        from checkout scanners in a representative sample of grocery stores across the US.
        Data spans October 6, 2019 to May 7, 2023."),
                  p(style = "color: #888; font-size: 13px;",
                    "Note: Alaska, Delaware, Hawaii, Idaho, Iowa, Kansas, Nebraska, New Jersey,
        North Dakota, Mississippi, Montana, and Washington D.C. are excluded as Circana
        does not collect state-level data in these locations.")
                ),
                
                # ── Feature cards ──
                h4("Explore the Data", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                fluidRow(
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                     box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                     border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("Spending by Category", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "See how much each state spends across grocery categories over the full dataset.")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                     box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                     border-top: 4px solid #f4a261; margin-bottom: 16px;",
                             h5("The COVID Pantry", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Explore how grocery spending shifted before and after COVID lockdowns in 2020.")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                     box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                     border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("Recipe Generator", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Pick your state and discover recipes inspired by what your state buys most.")
                         )
                  )
                ),
                fluidRow(
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                     box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                     border-top: 4px solid #f4a261; margin-bottom: 16px;",
                             h5("Grocery Prices", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Discover the average cost per unit of each grocery category by state.")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                     box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                     border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("Price by State", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Compare how the price of each grocery category varies across states.")
                         )
                  )
                ),
                
                # ── Data source footer ──
                div(
                  style = "text-align: center; padding: 16px; color: #aaa; font-size: 12px;",
                  p("Data source: USDA Weekly Retail Food Sales | Collected by Circana")
                )
              )
      ),
      tabItem(tabName = "BarByState",
              fluidPage(
                titlePanel("Dollars spent by state per category"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId  = "state_bar",
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
                      inputId  = "state_covid",
                      label    = "Select a State:",
                      choices  = sort(unique(outputstates$State)),
                      selected = "California"
                    ),
                    
                    selectInput(
                      inputId  = "category_covid",
                      label    = "Select a Category:",
                      choices  = sort(unique(outputstates$Category)),
                      selected = "Alcohol"
                    ),
                    
                    sliderInput(
                      inputId = "covid_marker",
                      label   = "Drag the COVID Marker:",
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
                    inputId  = "state_unit",
                    label    = "Select a State:",
                    choices  = sort(unique(outputstates$State)),
                    selected = "California"
                )
              ),
              mainPanel(
                plotOutput("UnitPrice")
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
                      inputId = "category_price",
                      label = "Select a Category:",
                      choices = sort(unique(outputstates$Category)),
                      selected = "Alcohol"
                    )
                  ),
                  mainPanel(
                    plotOutput("BarByCategory")
                  )
                ),
              ),
              ),
    tabItem(tabName = "Quiz",
            h3("Quiz yourself after reviweing our entire site"),
            radioButtons("q1",
                         "Which state is the most expensive to buy a vegtable in?",
                         choices = c("Michigan", "Vermont", "Rhode Island", "New York")),
            radioButtons("q2",
                         "What is the food item that is purchased the most in every state?",
                         choices = c("Commercially processed items", "Fruits", "Fats and oils", "Meats, eggs, and nuts")),
            radioButtons("q3",
                         "Which item is typically the most expensive per unit?",
                         choices = c("Vegtables", "Beverages", "Alcohol", "Meats, eggs, and nuts")),
            actionButton("submit_quiz", "Submit Quiz"),
            textOutput("quiz_result")
    )
  )
  )
)