library(shiny)
library(tidyverse)
library(tidyquant)

# Define server logic to plot a stock price chart
shinyServer(function(input, output) {
    
    output$plot1 <- renderPlot({
        # download stock price data based on years/ticker from ui.R
        end <- today()
        start <- today() - dyears(input$years)
        prices <- tq_get(input$ticker, from = start, to = end, get = "stock.prices") 
        dji <- tq_get("^DJI", from = start, to = end, get = "stock.prices")
        first.price <- prices$adjusted[1]
        prices$scaled <- prices$adjusted / first.price * 100
        first.dji <- dji$adjusted[1]
        dji$scaled <- dji$adjusted / first.dji * 100
        
        # plot stock price chart
        if(input$show.dji){
            df <- rbind(prices, dji)
            g <- ggplot(df, aes(x = date, y = scaled, color = symbol))
            g <- g + geom_line()
            g <- g + labs(title = paste("Stock Price of", input$ticker),
                          x = "date",
                          y = "daily stock price")
        } else {
            g <- ggplot(prices, aes(x = date, y = adjusted))
            g <- g + geom_line()
            g <- g + labs(title = paste("Stock Price of", input$ticker),
                          x = "date",
                          y = "daily stock price")
        }
        g
        
    })
    
    end2 <- today()
    start2 <- reactive({
        today() - dyears(input$years)
    })
    prices2 <- reactive({
        tq_get(input$ticker, from = start2(), to = end2, get = "stock.prices") 
    })
    stockReturn <- reactive({
        (prices2()$adjusted[length(prices2()$adjusted)]/prices2()$adjusted[1]) - 1
    })
    
    output$return1 <- renderText({
        sprintf("%1.2f%%", stockReturn() * 100)
    })
    
})
