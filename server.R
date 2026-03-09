library(tidyverse)
library(shiny)
source("CookBook.R")
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
  
  # Rank labels for top-3 cards
  rank_labels <- c("#1 Most Purchased", "#2 Most Purchased", "#3 Most Purchased")
    
    # ── Reactive: top-3 categories for selected state ──────────────────────────
    top3_data <- reactive({
      outputstates %>%
        filter(State == input$recipe_state) %>%
        group_by(Category) %>%
        summarise(total_dollars = sum(Dollars, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(total_dollars)) %>%
        slice_head(n = 3)
    })
    
    # ── Track which category is currently selected ─────────────────────────────
    selected_category <- reactiveVal(NULL)
    
    # Reset selection whenever state changes
    observeEvent(input$recipe_state, {
      selected_category(NULL)
    })
    
    # ── Render the 3 clickable cards ───────────────────────────────────────────
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
                 # Hidden button that triggers the server-side click
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
    
    # ── Observe card button clicks ─────────────────────────────────────────────
    observeEvent(input$card_click_1, {
      selected_category(top3_data()$Category[1])
    }, ignoreInit = TRUE)
    
    observeEvent(input$card_click_2, {
      selected_category(top3_data()$Category[2])
    }, ignoreInit = TRUE)
    
    observeEvent(input$card_click_3, {
      selected_category(top3_data()$Category[3])
    }, ignoreInit = TRUE)
    
    # ── Explore buttons (all categories) ──────────────────────────────────────
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
    
    # Observe each explore button
    lapply(all_categories, function(cat) {
      btn_id <- paste0("explore_", gsub("[^a-zA-Z]", "_", cat))
      observeEvent(input[[btn_id]], {
        selected_category(cat)
      }, ignoreInit = TRUE)
    })
    
    # ── Render the recipe card ─────────────────────────────────────────────────
    output$recipeOutput <- renderUI({
      cat <- selected_category()
      
      if (is.null(cat)) {
        div(
          style = "text-align:center; padding:50px; color:#bbb;",
          tags$img(src = "https://cdn-icons-png.flaticon.com/512/1830/1830839.png",
                   height = "60px", style = "opacity:0.3; margin-bottom:12px;"),
          br(),
          h4("Click a category card above to get a recipe!", style = "color:#ccc;")
        )
      } else {
        r <- if (!is.null(recipes[[cat]])) recipes[[cat]] else recipes[["Other"]]
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
               label = format(covid_date, "%b %d, %Y"),
               color = "firebrick", fill = "white", size = 3.5) +
      
      # Zero reference line
      geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
      
      scale_color_manual(values = c("Before" = "steelblue", "After" = "firebrick")) +
      
      labs(
        title   = paste(input$category, "Sales —", input$state),
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
    
    direction <- ifelse(after_avg > before_avg, "spiked UP", "dropped DOWN")
    diff      <- round(after_avg - before_avg, 1)
    
    wellPanel(
      h4("Quick Summary"),
      p(strong("Before marker:"), paste0("Avg YoY change = ", before_avg, "%")),
      p(strong("After marker:"),  paste0("Avg YoY change = ", after_avg, "%")),
      p(strong("Trend:"), paste(input$category, "in", input$state, direction,
                                "by", abs(diff), "percentage points after the marker."))
    )
    
  })
  
  output$BarPlot <- renderPlot({
    outputstates %>%
      filter(State == input$state) %>%                        # ← was "California"
      group_by(State, Category) %>%
      summarise(avg_unit_sales = mean(`Unit price`, na.rm = TRUE)) %>%
      ggplot(aes(x = reorder(Category, avg_unit_sales),
                 y = avg_unit_sales,
                 fill = Category)) +
      geom_col() +
      labs(
        title = paste("Average Unit Sales by Category -", input$state),  # ← dynamic title
        x = "Category",
        y = "Average Unit Sales"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      theme(legend.position = "none")
  })
}

