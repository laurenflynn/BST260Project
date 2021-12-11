#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(shinythemes)


#setwd("~/Desktop/CBQG/Fall 2021/Data Science/project")
nhanes <- load("filtered_for_shiny.Rda" )



    ui = fluidPage(
        # Change theme to yeti
        theme = shinythemes::shinytheme("yeti"),
        # Application title
        titlePanel("Visualizing NHANES Data"),
        
        # Create an app with 3 tabs
        tabsetPanel(
            # First tab: dietary supplements and age
            # histogram and a slider for age
            tabPanel("Dietary Supplements Across Ages",
                     sidebarLayout(
                         sidebarPanel(
                             # Add some text and a couple of hyper links before the slider for year
                             
                             # Add some space between the text above and animated
                             # slider bar below
                             br(),
                             
                             # Input: year slider with basic animation
                             sliderInput("age", "Age:",
                                         min = 18, max = 79,
                                         value = 50, 
                                         step = 1,
                                         sep = "",       
                                         ticks = FALSE,  # don't show tick marks on slider bar
                                         animate = FALSE) # add play button to animate
                         ),
                         
                         # Show a scatter plot for each age
                         mainPanel(
                             plotOutput("histSupplements")
                         )
                     )),
            
            # Second tab: look at family income poverty level vs a variety of body measures
            # Include dropdown menu of diseases to choose from 
            tabPanel("Income and Body Measures",
                     sidebarLayout(
                         sidebarPanel(
                             # Dropdown menu that allows the user to choose a measure
                             selectInput("body_measure", label = "Select a body measure of interest",
                                         choices = list("BMI", "Weight kg", "Waist Circumference cm", "Pulse 60 sec"))
                         ),
                         # Show a plot of income and selected body measure
                         mainPanel(
                             plotOutput("bmPlot")
                         )
                     )),
            #third tab of calories and dietary supplements
            tabPanel("Calories and Dietary Supplements",
                     sidebarLayout(
                         sidebarPanel(
                             selectInput("weightgoals", label="Filter among people who would like to weigh", choices=list("More", "Less", "The Same", "Any"))
                         ),
                         mainPanel(
                             plotOutput("kcalPlot")
                         )
                     )
                     
            )#end tab panel 3
        )
    )
    
    server = function(input, output) {
        
        # Scatterplot of fertility rate vs life expectancy
        output$histSupplements = renderPlot({
            # Filter year to be the input year from the slider
            filtered %>% filter(RIDAGEYR == input$age) %>%
                ggplot(aes(x=DSDCOUNT)) +
                geom_histogram() + 
                xlab("Number of  Dietary Supplements Taken") +
                ylab("Count") +scale_x_continuous( limits = c(0, 20)) +
                scale_y_continuous( limits = c(0, 85)) +
                # Change the title of the plot for each year
                # Returns a character vector containing a formatted combination 
                # of text and variable values
                ggtitle(sprintf("Dietary Supplements for Age %d", input$age)) +
                theme_bw()
        })
        
        #next make body measures plot
        
        output$bmPlot = renderPlot({
            # Filter to measure specified from dropdown menu
            if(input$body_measure=="BMI"){
                column <- filtered$BMXBMI
            }
            else if(input$body_measure=="Weight kg"){
                column <- filtered$BMXWT
            }
            else if(input$body_measure=="Waist Circumference cm"){
                column <- filtered$BMXWAIST
            }
            else{
                column <- filtered$BPXPLS
            }
            filtered %>% 
                ggplot(aes(x = INDFMPIR, y = column, color=Sex)) +
                geom_smooth() + xlab("Ratio of Family Income to Poverty Line") + ylab(input$body_measure) + ggtitle(sprintf("Comparing Ratio of Family Income to Povery vs. %s", input$body_measure)) + labs(color="Sex")
        })
        #lastly make calorie BMI Plot
        output$kcalPlot = renderPlot({
            if(input$weightgoals == "More") {
                f1 <- filtered %>% filter(WHQ040 == "1")
            }
            else if(input$weightgoals == "Less"){
                f1<- filtered %>% filter(WHQ040 == "2")
            }
            else if(input$weightgoals == "The Same"){
                f1 <- filtered %>% filter(WHQ040 == "3")
            }
            else{
                f1 <- filtered
            }
            
            
            #make third plot 
            f1%>% ggplot(aes(x=DR1TKCAL, y=BMXBMI,col=DSDCOUNT)) + geom_point(alpha=0.1) + ggtitle("Calories Consumed and BMI") + xlab("Calories Consumed (Square Root Scale)") + ylab("BMI (Square Root Scale)") + scale_x_sqrt(limits=c(0, 15000)) +scale_y_sqrt(limits=c(0, 85)) + labs(col="Number of Dietary Supplements Taken")
        })
        
    }

shinyApp(ui=ui, server=server)