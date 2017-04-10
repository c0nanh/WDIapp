#
# Coursera Developing Data Products Specialization

library("shiny")

# Define UI for WDI data
shinyUI(fluidPage(
  
  # Application title
  titlePanel("World Developing Indicators: GDP per capita and Life Expectancy"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("countryChecklist"),
      actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
      actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("GDP"),
      plotlyOutput("Life_Expectancy")
    )
  )
))

#add tab for documentation
#slider for time range
#average GDP / Life expectancy table?