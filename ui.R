library(shinydashboard)
library(shiny)
outputstates <- read.csv("outputstates.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(

  menuItem("About the project", tabName = "IntroPage"),  
    menuItem("Spending by Category", tabName = "BarByState"),
    menuItem("The COVID Pantry", tabName = "SalesDuringCovid"),
    menuItem("Recipe Generator", tabName = "Recipes"),
    menuItem("Grocery Prices", tabName = "UnitPricePerState"),
    menuItem("Price by State", tabName = "CategoryPricePerState"),
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
                  p("Groceries in the US is a project that utilizes the USDA’s Weekly Retail Food Sales data set, which used data collected from checkout scanners in a representative sample of grocery stores. This data was sent to a research firm that aggregated all of the results and organized them by week. Collections began on October 6, 2019 and ended on May 7, 2023. You may notice as you explore the pages of our project that certain states are missing. This is because Alaska, Delaware, Hawaii, Idaho, Iowa, Kansas, Nebraska, New Jersey, North Dakota, Mississippi, Montana, and Washington D.C. because the research firm used by the USDA (Circana) does not collect state-level data in these locations. Additionally, you will notice that grocery items are grouped into various categories. To help understand what items count in each category, we have provided a table below that summarizes the types of product considered under each category as outlined by the USDA, and some potential examples of these products. "),
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
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("Spending by Category", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Select a state to see total dollars spent per grocery category.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                fluidRow(
                  column(3,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                   border-top: 4px solid #e76f51;",
                           h5("Settings", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                           selectInput("state_bar", "Select a State:",
                                       choices  = sort(unique(outputstates$State)),
                                       selected = "California")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           plotOutput("BarPlot", height = "450px")
                         )
                  )
                )
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
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("The COVID Pantry", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Explore how grocery spending shifted before and after COVID lockdowns in 2020.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                fluidRow(
                  column(3,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                   border-top: 4px solid #e76f51;",
                           h5("Settings", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                           selectInput("state_covid", "Select a State:",
                                       choices  = sort(unique(outputstates$State)),
                                       selected = "California"),
                           selectInput("category_covid", "Select a Category:",
                                       choices  = sort(unique(outputstates$Category)),
                                       selected = "Alcohol"),
                           sliderInput("covid_marker", "Drag the COVID Marker:",
                                       min        = as.Date("2019-10-06"),
                                       max        = as.Date("2023-05-07"),
                                       value      = as.Date("2020-03-15"),
                                       step       = 7,
                                       timeFormat = "%b %d, %Y",
                                       animate    = FALSE),
                           hr(style = "border-color: #f4a261;"),
                           p("Drag the marker to explore how sales changed around COVID lockdowns.
            March 15, 2020 marks the start of widespread US lockdowns.",
                             style = "font-size: 12px; color: #888;")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           plotOutput("CovidPantry", height = "450px"),
                           br(),
                           uiOutput("summaryBox")
                         )
                  )
                )
              )
      ),
      tabItem(tabName = "UnitPricePerState",
              fluidPage(
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("Grocery Prices", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Select a state to see the average cost per unit across grocery categories.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                fluidRow(
                  column(3,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                   border-top: 4px solid #e76f51;",
                           h5("Settings", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                           selectInput("state_unit", "Select a State:",
                                       choices  = sort(unique(outputstates$State)),
                                       selected = "California")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           plotOutput("UnitPrice", height = "450px")
                         )
                  )
                )
              )
      ),
      tabItem(tabName = "CategoryPricePerState",
              fluidPage(
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("Price by State", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Select a category to compare average unit prices across all states.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                fluidRow(
                  column(3,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                   border-top: 4px solid #e76f51;",
                           h5("Settings", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                           selectInput("category_price", "Select a Category:",
                                       choices  = sort(unique(outputstates$Category)),
                                       selected = "Alcohol")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           plotOutput("BarByCategory", height = "450px")
                         )
                  )
                )
              )
      ),
      tabItem(tabName = "Quiz",
              fluidPage(
                tags$head(
                  tags$script(src = "https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js")
                ),
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("Quiz Time!", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Test your knowledge after exploring the site.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                div(
                  style = "background: white; border-radius: 14px; padding: 28px;
               box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                  h5("Question 1", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q1", "Which state is the most expensive to buy a vegetable in?",
                               choices = c("Michigan", "Vermont", "Rhode Island", "New York")),
                  hr(style = "border-color: #f4a261;"),
                  h5("Question 2", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q2", "What is the food category purchased the most in every state?",
                               choices = c("Commercially prepared items", "Fruits", "Fats and oils", "Meats")),
                  hr(style = "border-color: #f4a261;"),
                  h5("Question 3", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q3", "Which item is typically the most expensive per unit?",
                               choices = c("Vegetables", "Beverages", "Alcohol", "Meats")),
                  br(),
                  actionButton("submit_quiz", "Submit Quiz", class = "generate-btn"),
                  br(), br(),
                  uiOutput("quiz_result"),
                  tags$script(HTML("
        Shiny.addCustomMessageHandler('confetti', function(message) {
          confetti({
            particleCount: 200,
            spread: 90,
            origin: { y: 0.6 },
            colors: ['#e76f51', '#f4a261', '#2b2d42', '#ffffff']
          });
        });
      "))
                )
              )
      )
    )
  )
)