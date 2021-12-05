library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Stock Price Chart"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4("How to use: You can check stock prices by entering ticker name and number of years."),
            textInput("ticker", "Enter Ticker Name:", value = "^GSPC"),
            sliderInput("years", "Number of Years:",
                        min = 1, max = 10, value = 1),
            checkboxInput("show.dji", "Show DJI", value = TRUE),
            submitButton("Submit")
        ),
        
        # Show a plot of the stock price and stock price summary
        mainPanel(
            plotOutput("plot1"),
            h3("Total Return:"), 
            textOutput("return1")
        )
    )
))
