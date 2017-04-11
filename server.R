#
# Coursera Developing Data Products Specialization

library("WDI")
library("plotly")
#library("plyr")
library("shiny")

#SP.DYN.LE00.IN : Life expectancy at birth, total (years)
#NY.GDP.MKTP.CD : GDP (current US$)
#NY.GDP.PCAP.PP.KD : "GDP per capita, PPP (constant 2005 international $)"

START = 1990
END = 2014

dat = WDI(indicator=c("SP.DYN.LE00.IN","NY.GDP.PCAP.PP.KD"), 
          country=c("AR","AU","BR","CA","CN","FR","DE","IN","ID",
                    "IT","JP","KR","MX","RU","SA","ZA","TR","GB","US"), 
          start=START, end=END)

names(dat)[4] <- "Life_Expectancy"
names(dat)[5] <- "GDP_per_capita"

CountryList <- sort(unique(dat$country),decreasing=FALSE)
YearRange <- seq(START,END)

# Define server logic required to draw a histogram
shinyServer(function(input, output) { 

  # Define and initialize reactive values
  values <- reactiveValues()
  values$CountryList <- CountryList
  values$YearRange <- YearRange

  # Create UI from server side for year range and countries
#  output$YearRange <- renderUI({
#    sliderInput("range", 
#                label = h4("Year Range:"), 
#                min = START, 
#                max = END, 
#                value = c(min(values$YearRange), max(values$YearRange)),
#                format="####")
#  })
  
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

#  values$YearRange <- reactive({
#    seq(input$YearRange[1],input$YearRange[2]) 
#  })
  
  # data selection from user input
  filteredData <- reactive({
    dat[which(dat$country %in% input$CountryList), ]
  })
  
  output$Expected_Life <- renderText({
    paste("Mean Life Expectancy (years) for selected countries in final year = ", 
          signif(mean(dat[which(dat$country %in% input$CountryList & dat$year == END), ]$Life_Expectancy), digits = 5)
    )
  })
  
  output$Average_GDP <- renderText({
    paste("Mean GDP per capita ($) for selected countries in final year = ", 
          signif(mean(dat[which(dat$country %in% input$CountryList & dat$year == END), ]$GDP_per_capita), digits = 5)
    )
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
