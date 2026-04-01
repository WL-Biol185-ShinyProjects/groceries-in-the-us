library(tidyverse)
library(shinydashboard)
library(shiny)
library(leaflet)
outputstates <- read.csv("outputstates.csv")
merged_data <- read.csv("merged_data.csv")
dashboardPage(
  dashboardHeader(title = "Groceries in the US"),
  dashboardSidebar(
    sidebarMenu(id = "tabs",
                menuItem("About the project", tabName = "IntroPage"), 
                menuItem("Interactive Map", tabName = "InteractiveMap"),
                menuItem("Total Dollars Spent by State", tabName = "BarByState"),
                menuItem("Costs of Each Unit by State", tabName = "UnitPricePerState"),
                menuItem("Costs of Each Unit by Category", tabName = "CategoryPricePerState"),
                menuItem("The COVID Pantry", tabName = "SalesDuringCovid"),
                menuItem("Recipe Generator", tabName = "Recipes"),
                menuItem("Quiz Yourself", tabName = "Quiz"),
                menuItem("About the Authors", tabName = "AboutAuthors")
    )
  ),
  dashboardBody(
    tags$head(includeCSS("aes.css")),
    tabItems(
      tabItem(tabName = "IntroPage",
              fluidPage(
                
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 40px; margin-bottom: 24px;
               color: white; text-align: center;",
                  h1("Groceries in the US", style = "font-weight: 600; font-size: 36px;"),
                  p("Exploring American grocery spending patterns from 2019–2023",
                    style = "font-size: 16px; opacity: 0.9; margin-bottom: 0;")
                ),
                
                
                div(
                  style = "background: white; border-radius: 16px; padding: 28px;
               box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 24px;",
                  h4("About the Project", style = "color: #e76f51; font-weight: 600;"),
                  p("Groceries in the US is a project that utilizes the USDA's Weekly Retail Food Sales data set, which used data collected from checkout scanners in a representative sample of grocery stores. This data was sent to a research firm that aggregated all of the results and organized them by week. Collections began on October 6, 2019 and ended on May 7, 2023. Additionally, you will notice that grocery items are grouped into various categories. To help understand what items count in each category, we have provided a table below that summarizes the types of product considered under each category as outlined by the USDA, and some potential examples of these products. "),
                  p(style = "color: #888; font-size: 13px;",
                    "Note: Alaska, Delaware, Hawaii, Idaho, Iowa, Kansas, Nebraska, New Jersey,
        North Dakota, Mississippi, Montana, and Washington D.C. are excluded as Circana
        does not collect state-level data in these locations.")
                ),
                
                hr(style = "border-color: #f4a261; margin: 20px 0;"),
                h4("Grocery Category Guide", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                p(style = "font-size: 13px; color: #888; margin-bottom: 16px;",
                  "Food items are aggregated using the classification system developed for the Quarterly Food-at-Home Price Database, which distinguishes categories by their role in the Dietary Guidelines for Americans."),
                
                fluidRow(
                  column(6,
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #e76f51;",
                             h6("Alcohol", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Beer, wine, spirits and other alcoholic beverages.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #e76f51;",
                             h6("Beverages", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Water, carbonated non-alcoholic drinks, fruit drinks, non-carbonated sugary drinks, and other beverages.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #e76f51;",
                             h6("Commercially Prepared Items", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Canned soups and sauces, frozen pizzas and entrees, packaged meals, snacks, deli items, ice cream, baked goods, cookies, and candy.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #e76f51;",
                             h6("Dairy", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Cheese, low-fat milk, regular-fat milk, yogurt, and other dairy products.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #e76f51;",
                             h6("Fats and Oils", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Cooking oils and solid fats such as butter, margarine, and shortening.")
                         )
                  ),
                  column(6,
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #f4a261;",
                             h6("Fruits", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Fruit juice, whole canned fruit, and whole fresh or frozen fruit.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #f4a261;",
                             h6("Grains", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Packaged bread, rolls, tortillas, rice, pasta, cereal, flour, mixes, frozen grains, and other grain products.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #f4a261;",
                             h6("Meats, Eggs, and Nuts", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Poultry, beef and pork (fresh, frozen, and canned), eggs, fish (fresh, frozen, and canned), nuts, seeds, nut butters, and other protein foods.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #f4a261;",
                             h6("Sugar and Sweeteners", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Sugar, honey, syrup, artificial sweeteners, and other sweetening products.")
                         ),
                         div(style = "background: #fff9f5; border-radius: 12px; padding: 16px; margin-bottom: 12px; border-left: 4px solid #f4a261;",
                             h6("Vegetables", style = "color: #e76f51; font-weight: 600; margin-bottom: 6px;"),
                             p(style = "font-size: 12px; color: #666; margin-bottom: 0;", "Dark green, orange, starchy, legumes, and other vegetables — all available fresh, frozen, or canned.")
                         )
                  )
                ),
                p(style = "font-size: 11px; color: #bbb; margin-top: 8px;",
                  "Source: ",
                  tags$a("USDA Weekly Retail Food Sales Documentation",
                         href = "https://www.ers.usda.gov/data-products/weekly-retail-food-sales/documentation",
                         target = "_blank",
                         style = "color: #f4a261;")
                ),
                
                
                h4("Explore the Data", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                fluidRow(
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("Interactive Map", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Explore grocery spending per person across states on an interactive map."),
                             actionButton("nav_map", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #f4a261; margin-bottom: 16px;",
                             h5("Total Dollars Spent by State", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "See how much each state spends across grocery categories over the full dataset."),
                             actionButton("nav_spending", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("Costs of Each Unit by State", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Discover the average cost per unit of each grocery category by state."),
                             actionButton("nav_prices", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  )
                ),
                fluidRow(
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #f4a261; margin-bottom: 16px;",
                             h5("Costs of Each Unit by Category", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Compare how the price of each grocery category varies across states."),
                             actionButton("nav_pricestate", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #e76f51; margin-bottom: 16px;",
                             h5("The COVID Pantry", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Explore how grocery spending shifted before and after COVID lockdowns in 2020."),
                             actionButton("nav_covid", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  ),
                  column(4,
                         div(style = "background: white; border-radius: 14px; padding: 20px;
                 box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                 border-top: 4px solid #f4a261; margin-bottom: 16px;",
                             h5("Recipe Generator", style = "color: #e76f51; font-weight: 600;"),
                             p(style = "font-size: 13px; color: #666;",
                               "Pick your state and discover recipes inspired by what your state buys most."),
                             actionButton("nav_recipes", "Explore →",
                                          style = "background-color: #f4a261; color: white; border: none;
                 border-radius: 8px; padding: 6px 14px; font-size: 12px;
                 font-family: 'Poppins', sans-serif; margin-top: 8px;")
                         )
                  )
                ),
                div(
                  style = "background: #fff9f5; border-radius: 12px; padding: 16px;
           border-left: 4px solid #f4a261; margin-top: 24px;",
                  p(style = "font-size: 12px; color: #888; margin-bottom: 0;",
                    "Disclosure: Portions of the code used to build this website were generated with the guidance of AI tools such as Claude and ChatGPT.")
                ),
                div(
                  style = "text-align: center; margin: 10px 0;",
                  actionButton("surprise", "🎉",
                               style = "background: transparent; border: none; font-size: 11px;
             color: #ddd; cursor: pointer; padding: 4px 8px;
             font-family: 'Poppins', sans-serif;")
                ),
                
                div(
                  style = "text-align: center; padding: 16px; color: #aaa; font-size: 12px;",
                  p("Data source: USDA Weekly Retail Food Sales | Collected by Circana")
                )
              )
      ),
      tabItem(tabName = "InteractiveMap",
              fluidPage(
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 24px 32px; margin-bottom: 20px;
               color: white;",
                  h3("Interactive Map", style = "font-weight: 600; margin-bottom: 4px;"),
                  p("Explore grocery spending and units purchased per person across the US.",
                    style = "opacity: 0.9; margin-bottom: 0; font-size: 14px;")
                ),
                fluidRow(
                  column(3,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);
                   border-top: 4px solid #e76f51;",
                           h5("Settings", style = "color: #e76f51; font-weight: 600; margin-bottom: 16px;"),
                           selectInput("yearInput", "Select Year:",
                                       choices  = sort(unique(merged_data$Year)),
                                       selected = max(merged_data$Year)),
                           selectInput("categoryInput", "Select Category:",
                                       choices  = unique(merged_data$Category),
                                       selected = unique(merged_data$Category)[1]),
                           hr(style = "border-color: #f4a261;"),
                           p(style = "font-size: 12px; color: #888;",
                             "Spending and units are averaged per week within the selected year, then divided by state population.")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 16px;",
                           h5("Dollars Per Person", style = "color: #e76f51; font-weight: 600;"),
                           p(style = "font-size: 12px; color: #888; margin-bottom: 12px;",
                             "Average dollars spent per person per week on the selected category in the selected year."),
                           leafletOutput("InteractiveMap", height = 450)
                         ),
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           h5("Units Per Person", style = "color: #e76f51; font-weight: 600;"),
                           p(style = "font-size: 12px; color: #888; margin-bottom: 12px;",
                             "Average units purchased per person per week on the selected category in the selected year."),
                           leafletOutput("UnitsMap", height = 450)
                         ), 
                         
                         div(
                           style = "background: linear-gradient(135deg, #fff9f5, #fff3ec);
           border-radius: 14px; padding: 20px 24px; margin-top: 16px;
           border-left: 4px solid #e76f51;
           box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           h5("Why are Maine and New Hampshire so high?",
                              style = "color: #e76f51; font-weight: 600; margin-bottom: 10px;"),
                           p(style = "font-size: 13px; color: #555; margin-bottom: 6px;",
                             "Maine and New Hampshire consistently rank among the highest states for
     grocery spending per person. There are a few likely reasons for this:"),
                           tags$ul(
                             style = "font-size: 13px; color: #555; padding-left: 20px; margin-bottom: 0;",
                             tags$li(style = "margin-bottom: 6px;",
                                     strong("Harsh Winters:"),
                                     "Long cold winters mean people stock up heavily on shelf-stable goods like grains, canned goods, 
                                     and fats and oils for months at a time."),
                             tags$li(style = "margin-bottom: 6px;",
                                     strong("Cross-border shopping: "),
                                     "New Hampshire has no sales tax, making it a popular destination
             for shoppers from neighboring Massachusetts, Vermont, and Maine
             who cross state lines specifically to buy groceries."),
                             tags$li(style = "margin-bottom: 6px;",
                                     strong("Rural and self-sufficient culture: "),
                                     "These states have strong traditions of home cooking, canning,
             and food preparation from scratch, meaning residents tend to
             buy more raw ingredients than pre-made meals."),
                             tags$li(style = "margin-bottom: 0;",
                                     strong("Higher cost of living: "),
                                     "Grocery prices in the Northeast tend to be higher than the
             national average, which pushes up dollar spending even if
             the number of units purchased is similar to other states.")
                           )
                         )
                  )
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
                  p("Select a state to see total dollars spent per grocery category over the 182 weeks of data collection.",
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
                                       selected = "California"),
                           hr(style = "border-color: #f4a261;"),
                           uiOutput("topCategoryCard"),
                           hr(style = "border-color: #f4a261;"),
                           downloadButton("downloadBar", "Download Data",
                                          style = "background-color: #f4a261; color: white; border: none;
                                      border-radius: 8px; width: 100%; padding: 8px;
                                      font-family: 'Poppins', sans-serif;")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 16px;",
                           h5("Total Spending by Category", style = "color: #e76f51; font-weight: 600;"),
                           plotOutput("BarPlot", height = "350px")
                         ),
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           h5("Spending Over Time by Category", style = "color: #e76f51; font-weight: 600;"),
                           p(style = "font-size: 12px; color: #888; margin-bottom: 8px;",
                             "How has spending in each category changed week by week?"),
                           plotOutput("SpendingOverTime", height = "350px")
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
                  p("Select a state to see the average cost per unit across grocery categories, calculated using data from all 182 weeks of data collection.",
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
                                       selected = "California"),
                           hr(style = "border-color: #f4a261;"),
                           downloadButton("downloadUnitPrice", "Download Data",
                                          style = "background-color: #f4a261; color: white; border: none;
                                      border-radius: 8px; width: 100%; padding: 8px;
                                      font-family: 'Poppins', sans-serif;")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 16px;",
                           plotOutput("UnitPrice", height = "350px")
                         ),
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           h5("State vs. National Average Unit Price", style = "color: #e76f51; font-weight: 600;"),
                           p(style = "font-size: 12px; color: #888; margin-bottom: 8px;",
                             "How does this state compare to the national average for each category?"),
                           plotOutput("UnitPriceVsNational", height = "350px")
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
                  p("Select a category to compare average unit prices across all states, calculated using data from all 182 weeks of data collection.",
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
                                       selected = "Alcohol"),
                           hr(style = "border-color: #f4a261;"),
                           downloadButton("downloadCategoryPrice", "Download Data",
                                          style = "background-color: #f4a261; color: white; border: none;
                                      border-radius: 8px; width: 100%; padding: 8px;
                                      font-family: 'Poppins', sans-serif;")
                         )
                  ),
                  column(9,
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 16px;",
                           plotOutput("BarByCategory", height = "350px")
                         ),
                         div(
                           style = "background: white; border-radius: 14px; padding: 20px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06);",
                           h5("Price Over Time", style = "color: #e76f51; font-weight: 600;"),
                           p(style = "font-size: 12px; color: #888; margin-bottom: 8px;",
                             "How has the unit price of this category changed over time across states?"),
                           plotOutput("CategoryPriceOverTime", height = "350px")
                         )
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
                             style = "font-size: 12px; color: #888;"),
                           hr(style = "border-color: #f4a261;"),
                           downloadButton("downloadCovid", "Download Data",
                                          style = "background-color: #f4a261; color: white; border: none;
                                      border-radius: 8px; width: 100%; padding: 8px;
                                      font-family: 'Poppins', sans-serif;")
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
      tabItem(tabName = "Recipes",
              fluidPage(
                titlePanel("Dinner Recipe Generator"),
                br(),
                
                fluidRow(
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
                  
                  column(9,
                         h4("Top 3 Categories in Your State", style = "color:#e76f51; margin-top:6px;"),
                         p(style = "font-size:13px; color:#888; margin-bottom:14px;",
                           "Click a category card to see a recipe inspired by what your state buys most."),
                         
                         uiOutput("top3Cards"),
                         
                         div(class = "explore-header",
                             "Explore Other Recipes"),
                         p(style = "font-size:13px; color:#888; margin-bottom:10px;",
                           "Want to try something different? Pick any category below."),
                         uiOutput("exploreButtons"),
                         
                         br(),
                         
                         uiOutput("recipeOutput")
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
                  
                  uiOutput("quizProgress"),
                  br(),
                  
                  h5("Question 1", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q1", "Which state is the most expensive to buy vegetables in?",
                               choices = c("Michigan", "Vermont", "Rhode Island", "New York"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 2", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q2", "What is the food category purchased the most in every state?",
                               choices = c("Commercially prepared items", "Fruits", "Fats and oils", "Meats"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 3", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q3", "Which category is typically the most expensive per unit?",
                               choices = c("Vegetables", "Beverages", "Alcohol", "Meats"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 4", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q4", "Which state had the largest spike in grocery spending at the start of COVID?",
                               choices = c("Texas", "California", "New York", "Florida"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 5", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q5", "Which category saw the biggest increase in spending during COVID lockdowns?",
                               choices = c("Alcohol", "Commercially prepared items", "Grains", "Beverages"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 6", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q6", "Which state spends the least on groceries overall?",
                               choices = c("Wyoming", "Vermont", "South Dakota", "Maine"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 7", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q7", "The USDA data was collected by which research firm?",
                               choices = c("Nielsen", "Circana", "Gallup", "IRI"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  h5("Question 8", style = "color: #e76f51; font-weight: 600;"),
                  radioButtons("q8", "Which of these states is NOT included in the dataset?",
                               choices = c("Vermont", "Wyoming", "Montana", "Arkansas"),
                               selected = character(0)),
                  hr(style = "border-color: #f4a261;"),
                  
                  br(),
                  fluidRow(
                    column(6,
                           actionButton("submit_quiz", "Submit Quiz", class = "generate-btn",
                                        width = "100%")
                    ),
                    column(6,
                           actionButton("retake_quiz", "Retake Quiz",
                                        width = "100%",
                                        style = "background-color: white; color: #e76f51;
                                border: 2px solid #e76f51; border-radius: 10px;
                                font-size: 16px; padding: 10px 24px;
                                font-family: 'Poppins', sans-serif; font-weight: 600;
                                width: 100%;")
                    )
                  ),
                  
                  br(),
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
      ),
      tabItem(tabName = "AboutAuthors",
              fluidPage(
                div(
                  style = "background: linear-gradient(135deg, #e76f51, #f4a261);
               border-radius: 16px; padding: 40px; margin-bottom: 24px;
               color: white; text-align: center;",
                  h1("About the Authors", style = "font-weight: 600; font-size: 36px;"),
                  p("Meet the team behind Groceries in the US.",
                    style = "font-size: 16px; opacity: 0.9; margin-bottom: 0;")
                ),
                fluidRow(
                  column(4,
                         div(
                           style = "background: white; border-radius: 16px; padding: 28px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-align: center;",
                           img(src = "IMG_4562.jpg", height = "150px", width = "150px",
                               style = "border-radius: 50%; object-fit: cover; margin-bottom: 16px;
                       border: 4px solid #f4a261;"),
                           h4("Kate Scott", style = "color: #e76f51; font-weight: 600; margin-bottom: 8px;"),
                           p(style = "font-size: 13px; color: #666;",
                             "Kate Scott is a junior at Washington & Lee studying Neuroscience and Film on the pre-medical track. Her favorite grocery store is Kroger, and she loves baking and cooking with friends. In her free time, Kate enjoys hiking, rappelling, running, and playing guitar. She hopes that Groceries in the US serves as a useful tool for users to explore and analyze food related data. ")
                         )
                  ),
                  column(4,
                         div(
                           style = "background: white; border-radius: 16px; padding: 28px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-align: center;",
                           img(src = "NATE.jpeg", height = "150px", width = "150px",
                               style = "border-radius: 50%; object-fit: cover; margin-bottom: 16px;
                       border: 4px solid #f4a261;"),
                           h4("Nate Shriner", style = "color: #e76f51; font-weight: 600; margin-bottom: 8px;"),
                           p(style = "font-size: 13px; color: #666;",
                             "Nate Shriner is a junior at Washington & Lee studying Neuroscience with the aspiration of becoming a doctor one day. 
                             He believes the best medicine is nutrition and fitness. His favorite groccery store is H-E-B, and his favorite groccery category is meats, eggs, and nuts.")
                         )
                  ),
                  column(4,
                         div(
                           style = "background: white; border-radius: 16px; padding: 28px;
                   box-shadow: 0 2px 8px rgba(0,0,0,0.06); text-align: center;",
                           img(src = "IMG_4564.jpg", height = "150px", width = "150px",
                               style = "border-radius: 50%; object-fit: cover; margin-bottom: 16px;
                       border: 4px solid #f4a261;"),
                           h4("Elaina Bellone", style = "color: #e76f51; font-weight: 600; margin-bottom: 8px;"),
                           p(style = "font-size: 13px; color: #666;",
                             "Elaina Bellone is a junior at Washington & Lee University studying Biology and Education, with the intention of attending medical school. She has a passion for cooking with healthy, clean ingredients and believes that food is medicine. In her free time, Elaina enjoys playing field hockey and reading, and her favorite grocery store is Whole Foods. She hopes that Groceries in the US will help you explore the differences in cost and consumption across states, giving you a better idea of how access to groceries might vary across regions and by category.")
                         )
                  )
                )
              )
      )
    )
  )
)