	# TSA Covid-19 data visualizer - A PA TSA Data Science & Analytics project

library(shiny)
library(plotly)
library(COVID19)

# Define UI for application, including the User Interface layout and the input and output panels
ui <- fluidPage(
    titlePanel("Covid-19 Data Visualizer - a PA-TSA Data Science & Analytics Project"),
    theme = shinythemes::shinytheme("superhero"),
    sidebarLayout(
        sidebarPanel(
            selectInput("country", label = "Country", multiple = TRUE, choices = unique(covid19()$administrative_area_level_1), selected = "United States"),
            selectInput("type", label = "Type", choices = c("confirmed", "recovered", "deaths", "tests", "vaccines", "hosp", "icu", "vent")),
            selectInput("level", label = "Granularity", choices = c("Country" = 1, "Region" = 2, "City" = 3), selected = 1),
            dateRangeInput("date", label = "Date", start = "2020-01-01")
        ),
        mainPanel(
            plotlyOutput("covid19plot")
        )
    )
)

# Define server logic required to download and extract the Covid-19 data and display the selected data
# based on the parameters selected by the user
server <- function(input, output) {
    output$covid19plot <- renderPlotly({
        if(!is.null(input$country)){
            x <- covid19(country = input$country, level = input$level, start = input$date[1], end = input$date[2])
            color <- paste0("administrative_area_level_", input$level)
            plot_ly(x = x[["date"]], y = x[[input$type]], color = x[[color]])
        }
    })
}

# Run the application on a web browser
shinyApp(ui = ui, server = server)
