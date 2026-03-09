library(tidyverse)
library(shiny)
outputstates <- read.csv("outputstates.csv", check.names = FALSE)
# Define server logic required to draw a histogram
function(input, output) {
  
  output$BarPlot <- renderPlot({
    outputstates %>%
      filter(State == input$state) %>%                        # ← was "California"
      group_by(Category) %>%
      summarise(total_dollars = sum(Dollars, na.rm = TRUE)) %>%
      ggplot(aes(x = reorder(Category, total_dollars),
                 y = total_dollars,
                 fill = Category)) +
      geom_col() +
      labs(
        title = paste("Total Dollars Spent by Category -", input$state),  # ← dynamic title
        x = "Category",
        y = "Total Dollars"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      theme(legend.position = "none")
  })
  recipes <- list(
    
    "Fruits" = list(
      name = "Mango Glazed Salmon",
      desc = "A sweet and savory salmon fillet with a sticky mango glaze and fresh fruit salsa.",
      ingredients = "- 4 salmon fillets\n- 1 ripe mango, diced\n- 2 tbsp soy sauce\n- 1 tbsp honey\n- 1 lime, juiced\n- 1/2 red onion, diced\n- Fresh cilantro\n- Salt and pepper",
      instructions = "1. Preheat oven to 400F.\n2. Mix soy sauce, honey and lime juice to make the glaze.\n3. Season salmon with salt and pepper and brush with glaze.\n4. Bake for 15 minutes until cooked through.\n5. Mix remaining mango, red onion and cilantro to make salsa.\n6. Serve salmon topped with mango salsa.",
      fact = "Fun Fact: Mangoes are the most widely consumed fruit in the world."
    ),
    
    "Vegetables" = list(
      name = "Roasted Vegetable Pasta",
      desc = "A vibrant pasta tossed with oven-roasted vegetables and a light garlic olive oil sauce.",
      ingredients = "- 12 oz penne pasta\n- 1 zucchini, chopped\n- 1 cup cherry tomatoes\n- 1 red onion, chopped\n- 1 cup broccoli florets\n- 3 tbsp olive oil\n- 4 cloves garlic, minced\n- Salt, pepper, red pepper flakes\n- Parmesan to serve",
      instructions = "1. Preheat oven to 425F.\n2. Toss vegetables in 2 tbsp olive oil, salt and pepper.\n3. Roast for 25 minutes until tender and slightly charred.\n4. Cook pasta according to package directions.\n5. Heat remaining olive oil and saute garlic for 1 minute.\n6. Toss pasta with garlic oil and roasted vegetables.\n7. Serve with parmesan and red pepper flakes.",
      fact = "Fun Fact: Tomatoes were once considered poisonous in the United States."
    ),
    
    "Dairy" = list(
      name = "Creamy Mac and Cheese",
      desc = "The ultimate comfort food with a rich, velvety three-cheese sauce.",
      ingredients = "- 12 oz elbow macaroni\n- 2 tbsp butter\n- 2 tbsp flour\n- 2 cups whole milk\n- 1 cup shredded cheddar\n- 1/2 cup gruyere, shredded\n- 1/2 cup parmesan\n- Salt, pepper, mustard powder",
      instructions = "1. Cook pasta according to package directions and drain.\n2. Melt butter in a saucepan over medium heat.\n3. Whisk in flour and cook 1 minute.\n4. Slowly whisk in milk and cook until thickened, about 5 minutes.\n5. Remove from heat and stir in all cheeses until melted.\n6. Season with salt, pepper and mustard powder.\n7. Toss with pasta and serve immediately.",
      fact = "Fun Fact: The average American eats about 9 pounds of cheese per year."
    ),
    
    "Grains" = list(
      name = "Chicken and Rice Casserole",
      desc = "A comforting one-dish casserole with tender chicken and perfectly seasoned rice.",
      ingredients = "- 4 chicken thighs\n- 1 1/2 cups long grain rice\n- 3 cups chicken broth\n- 1 onion, diced\n- 3 cloves garlic, minced\n- 1 tsp thyme\n- 1 tsp paprika\n- Salt and pepper\n- 2 tbsp olive oil",
      instructions = "1. Preheat oven to 375F.\n2. Season chicken with paprika, salt and pepper.\n3. Sear chicken in olive oil in an oven-safe pan until golden, then set aside.\n4. Saute onion and garlic in the same pan for 3 minutes.\n5. Stir in rice, broth and thyme.\n6. Place chicken on top, cover and bake 45 minutes until rice is cooked.\n7. Rest 5 minutes before serving.",
      fact = "Fun Fact: Rice feeds more than half of the world's population every single day."
    ),
    
    "Meats" = list(
      name = "Juicy Herb Roasted Chicken",
      desc = "A golden, herb-crusted roasted chicken that fills the whole house with amazing smells.",
      ingredients = "- 4 chicken thighs\n- 2 tbsp olive oil\n- 1 tsp garlic powder\n- 1 tsp paprika\n- 1 tsp dried rosemary\n- Salt and pepper\n- 1 lemon, sliced",
      instructions = "1. Preheat oven to 425F.\n2. Mix olive oil and all spices together.\n3. Rub mixture all over the chicken.\n4. Place lemon slices under and around chicken in a baking dish.\n5. Roast for 35-40 minutes until golden and cooked through.\n6. Rest 5 minutes before serving.",
      fact = "Fun Fact: Chicken is the most consumed meat in the world."
    ),
    
    "Beverages" = list(
      name = "Beer Braised Beef Stew",
      desc = "A deeply rich and hearty beef stew slow-cooked in a savory broth for maximum flavor.",
      ingredients = "- 2 lbs beef chuck, cubed\n- 1 bottle dark beer\n- 2 cups beef broth\n- 3 carrots, chopped\n- 3 potatoes, cubed\n- 1 onion, diced\n- 3 cloves garlic\n- 2 tbsp tomato paste\n- Salt, pepper, thyme",
      instructions = "1. Season beef with salt and pepper and brown in batches in a large pot.\n2. Saute onion and garlic until softened.\n3. Stir in tomato paste and cook 1 minute.\n4. Add beer, broth, thyme and bring to a boil.\n5. Return beef to pot, cover and simmer 1.5 hours.\n6. Add carrots and potatoes and cook 30 more minutes until tender.\n7. Adjust seasoning and serve hot.",
      fact = "Fun Fact: Beer has been brewed for at least 7,000 years, making it one of the oldest beverages in human history."
    ),
    
    "Fats and oils" = list(
      name = "Golden Garlic Butter Shrimp Pasta",
      desc = "Succulent shrimp tossed in a rich garlic butter sauce over perfectly cooked linguine.",
      ingredients = "- 12 oz linguine\n- 1 lb shrimp, peeled\n- 4 tbsp butter\n- 3 tbsp olive oil\n- 5 cloves garlic, minced\n- 1/2 cup white wine or broth\n- Juice of 1 lemon\n- Fresh parsley\n- Salt and red pepper flakes",
      instructions = "1. Cook pasta according to package directions and reserve 1/2 cup pasta water.\n2. Heat butter and olive oil in a large skillet over medium heat.\n3. Add garlic and cook 1 minute until fragrant.\n4. Add shrimp and cook 2 minutes per side until pink.\n5. Pour in wine and lemon juice and simmer 2 minutes.\n6. Toss with pasta, adding pasta water as needed to loosen sauce.\n7. Top with parsley and serve immediately.",
      fact = "Fun Fact: Olive oil has been produced in the Mediterranean for over 6,000 years."
    ),
    
    "Sugar and sweeteners" = list(
      name = "Honey Garlic Glazed Pork Tenderloin",
      desc = "A perfectly tender pork loin with a sticky, caramelized honey garlic glaze.",
      ingredients = "- 2 pork tenderloins\n- 3 tbsp honey\n- 4 cloves garlic, minced\n- 2 tbsp soy sauce\n- 1 tbsp olive oil\n- 1 tsp dijon mustard\n- Salt and pepper",
      instructions = "1. Preheat oven to 400F.\n2. Mix honey, garlic, soy sauce and mustard together.\n3. Season pork with salt and pepper.\n4. Sear pork in olive oil in an oven-safe skillet until browned on all sides.\n5. Brush generously with honey glaze.\n6. Roast 20-25 minutes until internal temperature reaches 145F.\n7. Rest 5 minutes, slice and drizzle with pan juices.",
      fact = "Fun Fact: Honey never spoils. Archaeologists have found 3,000 year old honey in Egyptian tombs that was still edible."
    ),
    
    "Commercially prepared items" = list(
      name = "Loaded Taco Night",
      desc = "A fun and festive build-your-own taco spread the whole family will love.",
      ingredients = "- 1 lb ground beef\n- 1 packet taco seasoning\n- 8 taco shells\n- 1 cup shredded cheddar\n- 1 cup shredded lettuce\n- 2 tomatoes, diced\n- 1/2 cup sour cream\n- 1/2 cup salsa\n- 1 can refried beans",
      instructions = "1. Brown ground beef in a skillet over medium-high heat and drain fat.\n2. Stir in taco seasoning and 2/3 cup water and simmer 5 minutes.\n3. Warm taco shells in the oven according to package directions.\n4. Heat refried beans in a small saucepan.\n5. Set out all toppings in separate bowls.\n6. Let everyone build their own tacos and enjoy.",
      fact = "Fun Fact: Americans eat over 4.5 billion tacos every year."
    ),
    
    "Other" = list(
      name = "Cozy Vegetable Soup",
      desc = "A warming, wholesome soup that is perfect for any night of the week.",
      ingredients = "- 2 carrots, diced\n- 2 celery stalks, diced\n- 1 onion, diced\n- 2 potatoes, cubed\n- 4 cups vegetable broth\n- 1 can diced tomatoes\n- Salt, pepper, thyme",
      instructions = "1. Saute onion, carrots and celery in a large pot for 5 minutes.\n2. Add potatoes, broth and tomatoes.\n3. Season with salt, pepper and thyme.\n4. Bring to a boil then simmer for 20 minutes.\n5. Taste, adjust seasoning and serve hot.",
      fact = "Fun Fact: Soup is one of the oldest prepared foods, with evidence of soup-making dating back 20,000 years."
    )
  )
  

  recipe_result <- eventReactive(input$generateRecipe, {
    r <- if (!is.null(recipes[[input$recipe_category]])) {
      recipes[[input$recipe_category]]
    } else {
      recipes[["Other"]]
    }
    r
  })
  
  output$recipeOutput <- renderUI({
    if (input$generateRecipe == 0) {
      div(
        style = "text-align:center; padding: 60px; color: #aaa;",
        h4("Pick a state and category, then click Generate Recipe!", style = "color:#aaa;")
      )
    } else {
      r <- recipe_result()
      div(class = "recipe-box",
          div(class = "state-badge", paste0(input$recipe_state, " - ", input$recipe_category)),
          div(class = "recipe-title", r$name),
          p(em(r$desc)),
          h4("Ingredients"),
          p(style = "white-space:pre-wrap;", r$ingredients),
          h4("Instructions"),
          p(style = "white-space:pre-wrap;", r$instructions),
          hr(),
          p(style = "color:#e76f51; font-style:italic;", r$fact)
      )
    }
  })
  

  # ---- DEFINE filtered_data FIRST before anything uses it ----
  filtered_data <- reactive({
    outputstates %>%
      filter(
        State    == input$state,
        Category == input$category
      ) %>%
      mutate(Date = as.Date(Date)) %>%
      arrange(Date)
  })
  
  # --- The Covid Pantry ---
  output$CovidPantry <- renderPlot({
    
    df          <- filtered_data()
    covid_date  <- as.Date(input$covid_marker)
    
    # Label the periods
    df <- df %>%
      mutate(period = ifelse(Date < covid_date, "Before", "After"))
    
    ggplot(df, aes(x = Date, y = `Percent change dollars 1 year`, color = period)) +
      geom_line(aes(group = 1), color = "grey80", linewidth = 0.8) +
      geom_point(size = 2) +
      
      # Shaded regions
      annotate("rect",
               xmin = min(df$Date), xmax = covid_date,
               ymin = -Inf, ymax = Inf,
               fill = "steelblue", alpha = 0.07) +
      annotate("rect",
               xmin = covid_date, xmax = max(df$Date),
               ymin = -Inf, ymax = Inf,
               fill = "firebrick", alpha = 0.07) +
      
      # COVID marker line
      geom_vline(xintercept = covid_date,
                 color = "firebrick", linewidth = 1.2, linetype = "dashed") +
      annotate("label",
               x = covid_date, y = max(df$`Percent change dollars 1 year`, na.rm = TRUE),
               label = paste("📍", format(covid_date, "%b %d, %Y")),
               color = "firebrick", fill = "white", size = 3.5) +
      
      # Zero reference line
      geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
      
      scale_color_manual(values = c("Before" = "steelblue", "After" = "firebrick")) +
      
      labs(
        title   = paste("📦", input$category, "Sales —", input$state),
        subtitle = "% Change vs. Same Week Last Year",
        x       = "Date",
        y       = "% Change (Year over Year)",
        color   = "Period"
      ) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "bottom")
    
  })
  
  # --- Summary stats box below the chart ---
  output$summaryBox <- renderUI({
    
    df         <- filtered_data()
    covid_date <- as.Date(input$covid_marker)
    
    before_avg <- df %>%
      filter(Date < covid_date) %>%
      summarise(avg = mean(`Percent change dollars 1 year`, na.rm = TRUE)) %>%
      pull(avg) %>% round(1)
    
    after_avg <- df %>%
      filter(Date >= covid_date) %>%
      summarise(avg = mean(`Percent change dollars 1 year`, na.rm = TRUE)) %>%
      pull(avg) %>% round(1)
    
    direction <- ifelse(after_avg > before_avg, "📈 spiked UP", "📉 dropped DOWN")
    diff      <- round(after_avg - before_avg, 1)
    
    wellPanel(
      h4("📊 Quick Summary"),
      p(strong("Before marker:"), paste0("Avg YoY change = ", before_avg, "%")),
      p(strong("After marker:"),  paste0("Avg YoY change = ", after_avg, "%")),
      p(strong("Trend:"), paste(input$category, "in", input$state, direction,
                                "by", abs(diff), "percentage points after the marker."))
    )
    
  })
  

}
