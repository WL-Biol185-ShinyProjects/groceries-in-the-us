GROCERIES-IN-THE-US
An interactive Shiny app that explores grocery spending patterns across the United States using data from the USDA's Weekly Retail Food Sales dataset. This app was designed and built using data collected from October 2019 to May 2023. Users are able to explore total spending by state and category, examine how grocery habits shifted during COVID-19, compare unit prices across states, view per-capita spending on an interactive map, generate state-specific dinner recipes, and test their knowledge with a quiz.

Members
Kate Scott, Elaina Bellone, Nate Shriner

Tab Overview
About the Project:
An introduction to the project, a guide to the grocery categories used in the dataset, and links to each section of the app.
Interactive Map:
An interactive choropleth map showing average dollars spent and units purchased per person by state, filterable by year and grocery category.
Total Dollars Spent by State:
Explore total grocery spending by category for any state, including a time series showing how spending has changed week by week over the full dataset.
Costs of Each Unit by State:
View the average unit price per grocery category for a selected state, and see how that state compares to the national average across all categories.
Costs of Each Unit by Category:
Select a grocery category and compare average unit prices across all states, as well as how prices have trended over time for the top 5 states.
The COVID Pantry:
A before/after explorer that lets users drag a marker along a timeline to see how grocery spending changed around COVID-19 lockdowns in 2020.
Recipe Generator:
Select a state and see recipes inspired by the top 3 most purchased grocery categories in that state. Users can also explore recipes for any category.
Quiz Yourself:
An 8-question quiz testing knowledge of the data. Includes a progress bar, answer review, and confetti for a perfect score.
About the Authors:
Meet the team behind Groceries in the US.

Acknowledgements and Citations
Data:
USDA Economic Research Service (2023) — Weekly Retail Food Sales
https://www.ers.usda.gov/data-products/weekly-retail-food-sales/
US Census Bureau — State Population Estimates
https://www.census.gov/programs-surveys/popest.html
AI Usage:
Claude (Anthropic) — portions of the code for this app were generated with the assistance of AI.
https://claude.ai
ChatGPT (OpenAI) — portions of the code for this app were generated with the assistance of AI.
https://chatgpt.com

R Packages:

Shiny — https://shiny.posit.co
shinydashboard — https://rstudio.github.io/shinydashboard
tidyverse — https://www.tidyverse.org
leaflet — https://rstudio.github.io/leaflet
sf — https://r-spatial.github.io/sf
plotly — https://plotly.com/r
