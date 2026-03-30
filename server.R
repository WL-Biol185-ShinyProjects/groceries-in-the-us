library(tidyverse)
library(shiny)
library(sf)
library(leaflet)
source("CookBook.R")
merged_data <- read.csv("merged_data.csv")
outputstates <- read.csv("outputstates.csv", check.names = FALSE)

function(input, output, session) {
  
  grocery_theme <- theme_minimal(base_size = 14) +
    theme(
      plot.background   = element_rect(fill = "#fff9f5", color = NA),
      panel.background  = element_rect(fill = "#fff9f5", color = NA),
      plot.title        = element_text(color = "#e76f51", face = "bold", size = 15),
      plot.subtitle     = element_text(color = "#888888", size = 11),
      axis.text         = element_text(color = "#555555"),
      axis.title        = element_text(color = "#555555"),
      panel.grid.major  = element_line(color = "#f0e6de"),
      panel.grid.minor  = element_blank(),
      legend.background = element_rect(fill = "#fff9f5", color = NA),
      axis.text.x       = element_text(angle = 45, hjust = 1)
    )
  
  output$BarPlot <- renderPlot({
    outputstates %>%
      filter(State == input$state_bar) %>%                        
      group_by(Category) %>%
      summarise(total_dollars = sum(Dollars, na.rm = TRUE)) %>%
      ggplot(aes(x = reorder(Category, total_dollars),
                 y = total_dollars,
                 fill = Category)) +
      geom_col() +
      labs(
        title = paste("Total Dollars Spent by Category -", input$state_bar),  
        x = "Category",
        y = "Total Dollars"
      ) +
      grocery_theme +
      theme(legend.position = "none")
  })
  

  rank_labels <- c("#1 Most Purchased", "#2 Most Purchased", "#3 Most Purchased")
  

    top3_data <- reactive({
      outputstates %>%
        filter(State == input$recipe_state) %>%
        group_by(Category) %>%
        summarise(total_dollars = sum(Dollars, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(total_dollars)) %>%
        slice_head(n = 3)
    })
    

    selected_category <- reactiveVal(NULL)
    

    observeEvent(input$recipe_state, {
      selected_category(NULL)
    })
    

    output$top3Cards <- renderUI({
      top3 <- top3_data()
      cards <- lapply(seq_len(nrow(top3)), function(i) {
        cat_name  <- top3$Category[i]
        dollars   <- scales::dollar(top3$total_dollars[i], scale = 1e-6,
                                    suffix = "B", accuracy = 0.1)
        is_sel    <- !is.null(selected_category()) && selected_category() == cat_name
        card_cls  <- if (is_sel) "top3-card selected" else "top3-card"
        
        column(4,
               div(
                 class = card_cls,
                 id    = paste0("card_", i),
                 div(class = "card-rank",     rank_labels[i]),
                 div(class = "card-category", cat_name),
                 div(class = "card-dollars",  paste0("$", round(top3$total_dollars[i] / 1e9, 1), "B total spent")),
                
                 actionButton(
                   inputId = paste0("card_click_", i),
                   label   = "",
                   style   = "position:absolute; opacity:0; width:100%; height:100%; top:0; left:0; cursor:pointer; border:none; background:transparent;"
                 )
               ) %>% tagAppendAttributes(style = "position:relative;")
        )
      })
      fluidRow(cards)
    })
    

    observeEvent(input$card_click_1, {
      selected_category(top3_data()$Category[1])
    }, ignoreInit = TRUE)
    
    observeEvent(input$card_click_2, {
      selected_category(top3_data()$Category[2])
    }, ignoreInit = TRUE)
    
    observeEvent(input$card_click_3, {
      selected_category(top3_data()$Category[3])
    }, ignoreInit = TRUE)
    

    all_categories <- names(recipes)
    
    output$exploreButtons <- renderUI({
      btns <- lapply(all_categories, function(cat) {
        is_sel  <- !is.null(selected_category()) && selected_category() == cat
        btn_cls <- if (is_sel) "explore-btn active-explore" else "explore-btn"
        actionButton(
          inputId = paste0("explore_", gsub("[^a-zA-Z]", "_", cat)),
          label   = cat,
          class   = btn_cls
        )
      })
      div(btns)
    })
    

    lapply(all_categories, function(cat) {
      btn_id <- paste0("explore_", gsub("[^a-zA-Z]", "_", cat))
      observeEvent(input[[btn_id]], {
        selected_category(cat)
      }, ignoreInit = TRUE)
    })
    

    output$recipeOutput <- renderUI({
      cat <- selected_category()
      if (!is.null(cat) && cat == "Meats, eggs, and nuts") cat <- "Meats"
    
      if (is.null(cat)) {
        div(
          style = "text-align:center; padding:50px; color:#bbb;",
          tags$img(src = "https://cdn-icons-png.flaticon.com/512/1830/1830839.png",
                   height = "60px", style = "opacity:0.3; margin-bottom:12px;"),
          br(),
          h4("Click a category card above to get a recipe!", style = "color:#ccc;")
        )
      } else {
        r <- if (!is.null(recipes[[cat]][[input$recipe_state]])) {
          recipes[[cat]][[input$recipe_state]]
        } else if (!is.null(recipes[[cat]][["default"]])) {
          recipes[[cat]][["default"]]
        } else {
          recipes[["Other"]][["default"]]
        }
        div(class = "recipe-box",
            div(class = "state-badge", paste0(input$recipe_state, "  ·  ", cat)),
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
    filtered_data <- reactive({
      outputstates %>%
        filter(
          State    == input$state_covid,
          Category == input$category_covid
        ) %>%
        mutate(Date = as.Date(Date)) %>%
        arrange(Date)
    })

  output$CovidPantry <- renderPlot({
    
    df          <- filtered_data()
    covid_date  <- as.Date(input$covid_marker)
    

    df <- df %>%
      mutate(period = ifelse(Date < covid_date, "Before", "After"))
    
    ggplot(df, aes(x = Date, y = `Percent change dollars 1 year`, color = period)) +
      geom_line(aes(group = 1), color = "grey80", linewidth = 0.8) +
      geom_point(size = 2) +
      

      annotate("rect",
               xmin = min(df$Date), xmax = covid_date,
               ymin = -Inf, ymax = Inf,
               fill = "steelblue", alpha = 0.07) +
      annotate("rect",
               xmin = covid_date, xmax = max(df$Date),
               ymin = -Inf, ymax = Inf,
               fill = "firebrick", alpha = 0.07) +
      

      geom_vline(xintercept = covid_date,
                 color = "firebrick", linewidth = 1.2, linetype = "dashed") +
      annotate("label",
               x = covid_date, y = max(df$`Percent change dollars 1 year`, na.rm = TRUE),
               label = format(covid_date, "%b %d, %Y"),
               color = "firebrick", fill = "white", size = 3.5) +
      

      geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
      
      scale_color_manual(values = c("Before" = "steelblue", "After" = "firebrick")) +
      
      labs(
        title   = paste(input$category_covid, "Sales —", input$state_covid),
        subtitle = "% Change vs. Same Week Last Year",
        x       = "Date",
        y       = "% Change (Year over Year)",
        color   = "Period"
      ) +
      grocery_theme +
      theme(legend.position = "none")
  })
  

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
    
    direction <- ifelse(after_avg > before_avg, "spiked UP", "dropped DOWN")
    diff      <- round(after_avg - before_avg, 1)
    
    wellPanel(
      h4("Quick Summary"),
      p(strong("Before marker:"), paste0("Avg YoY change = ", before_avg, "%")),
      p(strong("After marker:"),  paste0("Avg YoY change = ", after_avg, "%")),
      p(strong("Trend:"), paste(input$category_covid, "in", input$state_covid, direction,
                                "by", abs(diff), "percentage points after the marker."))
    )
    
  })
  
  output$UnitPrice <- renderPlot({
   outputstates %>%
      filter(State == input$state_unit) %>%                        
      group_by(State, Category) %>%
      summarise(avg_unit_sales = mean(`Unit price`, na.rm = TRUE)) %>%
      ggplot(aes(x = reorder(Category, avg_unit_sales),
                 y = avg_unit_sales,
                 fill = Category)) +
      geom_col() +
      labs(
        title = paste("Average Unit Price By Category -", input$state_unit),  
        x = "Category",
        y = "Average Unit Price"
      ) +
      grocery_theme +
      theme(legend.position = "none")
  })
  
  output$BarByCategory <- renderPlot({
   outputstates %>%
      filter(Category == input$category_price) %>%                        
      group_by(State) %>%
      summarise(avg_unit_sales = mean(`Unit price`, na.rm = TRUE)) %>%
      ggplot(aes(x = reorder(State, avg_unit_sales),
                 y = avg_unit_sales,
                 fill = State)) +
      geom_col() +
      labs(
        title = paste("Average Unit Price per State -", input$category_price),  
        x = "State",
        y = "Average Unit Price"
      ) +
      grocery_theme +
      theme(legend.position = "none")
  })
  
  correct_answers <- list(
    q1 = "Vermont",
    q2 = "Commercially prepared items",
    q3 = "Alcohol",
    q4 = "New York",
    q5 = "Grains",
    q6 = "Wyoming",
    q7 = "Circana",
    q8 = "Montana"
  )
  
  question_text <- list(
    q1 = "Which state is the most expensive to buy vegetables in?",
    q2 = "What is the food category purchased the most in every state?",
    q3 = "Which category is typically the most expensive per unit?",
    q4 = "Which state had the largest spike in grocery spending at the start of COVID?",
    q5 = "Which category saw the biggest increase in spending during COVID lockdowns?",
    q6 = "Which state spends the least on groceries overall?",
    q7 = "The USDA data was collected by which research firm?",
    q8 = "Which of these states is NOT included in the dataset?"
  )
  
  
  
  output$quizProgress <- renderUI({
    answered <- sum(c(
      input$q1 != "", input$q2 != "", input$q3 != "",
      input$q4 != "", input$q5 != "", input$q6 != "",
      input$q7 != "", input$q8 != ""
    ))
    pct <- round((answered / 8) * 100)
    div(
      p(style = "font-size: 13px; color: #888; margin-bottom: 6px;",
        paste0(answered, " of 8 questions answered")),
      div(
        style = "background: #f0e6de; border-radius: 8px; height: 10px; width: 100%;",
        div(style = paste0("background: #e76f51; border-radius: 8px; height: 10px; width: ",
                           pct, "%; transition: width 0.3s ease;"))
      )
    )
  })
  
  
  observeEvent(input$submit_quiz, {
    user_answers <- list(
      q1 = input$q1, q2 = input$q2, q3 = input$q3,
      q4 = input$q4, q5 = input$q5, q6 = input$q6,
      q7 = input$q7, q8 = input$q8
    )
    
    score <- sum(mapply(function(user, correct) user == correct,
                        user_answers, correct_answers))
    
    output$quiz_result <- renderUI({
      
      banner_color <- if (score == 8) "#e76f51" else if (score >= 5) "#f4a261" else "#aaa"
      
      result_rows <- lapply(names(correct_answers), function(q) {
        user    <- user_answers[[q]]
        correct <- correct_answers[[q]]
        is_right <- user == correct
        div(
          style = paste0("padding: 12px; border-radius: 10px; margin-bottom: 10px; ",
                         "background: ", if (is_right) "#f0fff4" else "#fff0f0", ";",
                         "border-left: 4px solid ", if (is_right) "#55efc4" else "#e76f51", ";"),
          p(style = "font-size: 13px; color: #555; margin-bottom: 4px;",
            strong(question_text[[q]])),
          p(style = paste0("font-size: 13px; margin-bottom: 0; color: ",
                           if (is_right) "#27ae60" else "#e76f51", ";"),
            if (is_right) paste0(" ", user) else paste0("Your answer: ", user,
                                                         "  |  Correct: ", correct))
        )
      })
      
      div(
        div(
          style = paste0("text-align: center; padding: 20px; background: ",
                         banner_color, "; border-radius: 12px; color: white; margin-bottom: 20px;"),
          h3(if (score == 8) "🎉 Perfect Score!" else paste0("You got ", score, " out of 8"),
             style = "font-weight: 600; margin-bottom: 4px;"),
          p(if (score == 8) "You really know your groceries!"
            else if (score >= 5) "Nice work! Review the site and try again."
            else "Keep exploring the site and try again!",
            style = "margin-bottom: 0; opacity: 0.9;")
        ),
        h5("Answer Review", style = "color: #e76f51; font-weight: 600; margin-bottom: 12px;"),
        tagList(result_rows)
      )
    })
    
    if (score == 8) {
      session$sendCustomMessage("confetti", list())
    }
  })
  
  
  observeEvent(input$retake_quiz, {
    updateRadioButtons(session, "q1", selected = character(0))
    updateRadioButtons(session, "q2", selected = character(0))
    updateRadioButtons(session, "q3", selected = character(0))
    updateRadioButtons(session, "q4", selected = character(0))
    updateRadioButtons(session, "q5", selected = character(0))
    updateRadioButtons(session, "q6", selected = character(0))
    updateRadioButtons(session, "q7", selected = character(0))
    updateRadioButtons(session, "q8", selected = character(0))
    output$quiz_result <- renderUI({ NULL })
  }) 
    
  output$quiz_result <- renderUI({ NULL })
  
  output$topCategoryCard <- renderUI({
    top <- outputstates %>%
      filter(State == input$state_bar) %>%
      group_by(Category) %>%
      summarise(total = sum(Dollars, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(total)) %>%
      slice_head(n = 1)
    
    div(
      style = "background: #fff0e6; border-radius: 10px; padding: 14px;
             border-left: 4px solid #e76f51; margin-top: 8px;",
      p(style = "font-size: 11px; color: #aaa; margin-bottom: 4px; text-transform: uppercase;
               letter-spacing: 1px;", "Top Category"),
      p(style = "font-size: 16px; font-weight: 600; color: #e76f51; margin-bottom: 4px;",
        top$Category),
      p(style = "font-size: 12px; color: #888; margin-bottom: 0;",
        paste0("$", round(top$total / 1e9, 1), "B total spent"))
    )
  })
  output$SpendingOverTime <- renderPlot({
    outputstates %>%
      filter(State == input$state_bar) %>%
      mutate(Date = as.Date(Date)) %>%
      group_by(Date, Category) %>%
      summarise(total = sum(Dollars, na.rm = TRUE), .groups = "drop") %>%
      ggplot(aes(x = Date, y = total, color = Category)) +
      geom_line(linewidth = 0.8, alpha = 0.8) +
      scale_y_continuous(labels = scales::dollar_format(scale = 1e-6, suffix = "M")) +
      labs(
        title = paste("Weekly Spending Over Time —", input$state_bar),
        x = "Date", y = "Dollars (Millions)", color = "Category"
      ) +
      grocery_theme +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 45, hjust = 1))
  })
  output$InteractiveMap <- renderLeaflet({ 
    states <- read_sf("states.geo.json")
    mapData <- left_join(states, 
                         merged_data %>% 
                           filter(Year == input$yearInput,
                                  Category == input$categoryInput),
                         by = c("NAME" = "State"))
    pal <- colorBin("YlOrRd", domain = mapData$DollarsPerPerson)
    leaflet(mapData) %>% 
      setView(lng = -98, lat = 39, zoom = 4) %>%   
      addPolygons(
        fillColor = ~pal(DollarsPerPerson),
        fillOpacity = 0.7,
        color = "white",
        weight = 1,
        label = ~paste(NAME, ": ", round(DollarsPerPerson, 2))
      ) %>%
      addLegend(
        pal = pal,
        values = ~DollarsPerPerson,
        title = "Dollars per Person",
        position = "bottomright"
      )
  })
  output$UnitsMap <- renderLeaflet({ 
    states <- read_sf("states.geo.json")
    mapData <- left_join(states, 
                         merged_data %>% 
                           filter(Year == input$yearInput,
                                  Category == input$categoryInput),
                         by = c("NAME" = "State"))
    pal <- colorBin("Blues", domain = mapData$UnitsPerPerson)
    leaflet(mapData) %>% 
      setView(lng = -98, lat = 39, zoom = 4) %>%   
      addPolygons(
        fillColor = ~pal(UnitsPerPerson),
        fillOpacity = 0.7,
        color = "white",
        weight = 1,
        label = ~paste(NAME, ": ", round(UnitsPerPerson, 2))
      ) %>%
      addLegend(
        pal = pal,
        values = ~UnitsPerPerson,
        title = "Units per Person",
        position = "bottomright"
      )
  })
  output$UnitPriceVsNational <- renderPlot({
    national_avg <- outputstates %>%
      group_by(Category) %>%
      summarise(national_avg = mean(`Unit price`, na.rm = TRUE), .groups = "drop")
    
    state_avg <- outputstates %>%
      filter(State == input$state_unit) %>%
      group_by(Category) %>%
      summarise(state_avg = mean(`Unit price`, na.rm = TRUE), .groups = "drop")
    
    left_join(state_avg, national_avg, by = "Category") %>%
      mutate(diff = state_avg - national_avg) %>%
      ggplot(aes(x = reorder(Category, diff), y = diff,
                 fill = ifelse(diff > 0, "Above Average", "Below Average"))) +
      geom_col() +
      scale_fill_manual(values = c("Above Average" = "#e76f51",
                                   "Below Average" = "#74b9ff")) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "#888") +
      labs(
        title = paste(input$state_unit, "vs. National Average Unit Price"),
        x = "Category", y = "Difference ($)", fill = ""
      ) +
      grocery_theme +
      theme(legend.position = "bottom")
  })
  output$CategoryPriceOverTime <- renderPlot({
    top_states <- outputstates %>%
      filter(Category == input$category_price) %>%
      group_by(State) %>%
      summarise(avg = mean(`Unit price`, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(avg)) %>%
      slice_head(n = 5) %>%
      pull(State)
    
    outputstates %>%
      filter(Category == input$category_price, State %in% top_states) %>%
      mutate(Date = as.Date(Date)) %>%
      ggplot(aes(x = Date, y = `Unit price`, color = State)) +
      geom_line(linewidth = 0.8, alpha = 0.8) +
      labs(
        title = paste(input$category_price, "— Unit Price Over Time (Top 5 States)"),
        x = "Date", y = "Unit Price ($)", color = "State"
      ) +
      grocery_theme +
      theme(legend.position = "bottom")
  })
  
  output$downloadBar <- downloadHandler(
    filename = function() paste0(input$state_bar, "_spending_by_category.csv"),
    content  = function(file) {
      outputstates %>%
        filter(State == input$state_bar) %>%
        write.csv(file, row.names = FALSE)
    }
  )
  
  output$downloadCovid <- downloadHandler(
    filename = function() paste0(input$state_covid, "_", input$category_covid, "_covid.csv"),
    content  = function(file) {
      outputstates %>%
        filter(State == input$state_covid, Category == input$category_covid) %>%
        write.csv(file, row.names = FALSE)
    }
  )
  
  output$downloadUnitPrice <- downloadHandler(
    filename = function() paste0(input$state_unit, "_unit_prices.csv"),
    content  = function(file) {
      outputstates %>%
        filter(State == input$state_unit) %>%
        write.csv(file, row.names = FALSE)
    }
  )
  
  output$downloadCategoryPrice <- downloadHandler(
    filename = function() paste0(input$category_price, "_price_by_state.csv"),
    content  = function(file) {
      outputstates %>%
        filter(Category == input$category_price) %>%
        write.csv(file, row.names = FALSE)
    }
  )
  observeEvent(input$surprise, {
    session$sendCustomMessage("confetti", list())
  })
  
  observeEvent(input$nav_map,        { updateTabItems(session, "tabs", "InteractiveMap") })
  observeEvent(input$nav_spending,   { updateTabItems(session, "tabs", "BarByState") })
  observeEvent(input$nav_prices,     { updateTabItems(session, "tabs", "UnitPricePerState") })
  observeEvent(input$nav_pricestate, { updateTabItems(session, "tabs", "CategoryPricePerState") })
  observeEvent(input$nav_covid,      { updateTabItems(session, "tabs", "SalesDuringCovid") })
  observeEvent(input$nav_recipes,    { updateTabItems(session, "tabs", "Recipes") })
}

