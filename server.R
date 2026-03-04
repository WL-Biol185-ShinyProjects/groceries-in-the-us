library(tidyverse)
library(shiny)
outputstates <- read.csv("outputstates.csv", check.names = FALSE)
# Define server logic required to draw a histogram
function(input, output) {
  
  output$BarByState <- renderPlot({
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
  
  # --- Main chart ---
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