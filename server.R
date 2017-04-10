#
# Coursera Developing Data Products Specialization

library("WDI")
library("plotly")
library("plyr")
library("shiny")

#SP.DYN.LE00.IN : Life expectancy at birth, total (years)
#NY.GDP.MKTP.CD : GDP (current US$)
#NY.GDP.PCAP.PP.KD : "GDP per capita, PPP (constant 2005 international $)"

dat = WDI(indicator=c("SP.DYN.LE00.IN","NY.GDP.PCAP.PP.KD"), country=c("AR","AU","BR","CA","CN","FR","DE","IN","ID","IT","JP","KR","MX","RU","SA","ZA","TR","GB","US"), start=1985, end=2014)

names(dat)[4] <- "Life_Expectancy"
names(dat)[5] <- "GDP_per_capita"

CountryList <- sort(unique(dat$country),decreasing=FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) { 

  # Define and initialize reactive values
  values <- reactiveValues()
  values$CountryList <- CountryList

  # Create event type checkbox
  output$countryChecklist <- renderUI({
    checkboxGroupInput("CountryList",
                       label = h4("Countries"), 
                       choices = CountryList, 
                       selected = values$CountryList)
  })  
    
  # Add observers on clear and select all buttons
  observe({
    if(input$clear_all == 0) return()
    values$CountryList <- c()
  })
  
  observe({
    if(input$select_all == 0) return()
    values$CountryList <- CountryList
  })  
  
  filteredData <- reactive({ 
    dat[dat$country %in% input$CountryList, ]
  })
  
  output$GDP <- renderPlotly({
    plot_ly(
      filteredData(),  
      x = ~year,
      y = ~GDP_per_capita,
      split = ~country,
      mode = "lines + markers",
      hoverinfo = "y" 
    )%>%
      layout(autosize = T, width = "auto", height = "auto")
  })
  
  output$Life_Expectancy <- renderPlotly({
    plot_ly(
      filteredData(),  
      x = ~year,
      y = ~Life_Expectancy,
      split = ~country,
      mode = "lines + markers",
      hoverinfo = "y" 
    )%>%
      layout(autosize = T, width = "auto", height = "auto")  
  
  })
  
  
})
