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
        titlePanel("Visualizing NHANES data"),
        
        # Create an app with 3 tabs
        tabsetPanel(
            # First tab: dietary supplements and age
            # histogram and a slider for age
            tabPanel("Dietary supplements across ages",
                     sidebarLayout(
                         sidebarPanel(
                             # Add some text and a couple of hyper links before the slider for year
                             
                             # Add some space between the text above and animated
                             # slider bar below
                             
                             
                             # Input: year slider with basic animation
                             sliderInput("age", "Age:",
                                         min = 18, max = 79,
                                         value = 50, 
                                         step = 1,
                                         sep = "",       
                                         ticks = FALSE,  # don't show tick marks on slider bar
                                         animate = FALSE), # add play button to animate
                             br(),
                             p("Drag the slider bar to the left and right to look at the number of dietary supplements taken for individuals at each age.")
                         ),
                         
                         # Show a scatter plot for each age
                         mainPanel(
                             plotOutput("histSupplements")
                         )
                     )),
            
            # Second tab: look at family income poverty level vs a variety of body measures
            # Include dropdown menu of diseases to choose from 
            tabPanel("Income and body measures",
                     sidebarLayout(
                         sidebarPanel(
                             # Dropdown menu that allows the user to choose a measure
                             selectInput("body_measure", label = "Select a body measure of interest",
                                         choices = list("BMI", "Weight (kg)", "Waist circumference (cm)", "Pulse (60 sec)")),
                             br(),
                             p("We are interested in the relationship between different body measures with income and biological sex. In each graph, we can see a clear discrepancy between males and females as well as between those living close to the poverty line and those who have a higher income.")
                         ),
                         # Show a plot of income and selected body measure
                         mainPanel(
                             plotOutput("bmPlot")
                         )
                     )),
            #third tab of calories and dietary supplements
            tabPanel("Calories and dietary supplements",
                     sidebarLayout(
                         sidebarPanel(
                             selectInput("weightgoals", label="Filter among people who would like to weigh", choices=list("More", "Less", "The same", "Any")),
                             br(),
                             p("Caloric restriction is often used as a strategy for weight control. Here, we can compare daily caloric intake with BMI based on each individual's weight goals.")
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
                xlab("Number of  dietary supplements taken") +
                ylab("Count") +scale_x_continuous( limits = c(0, 20)) +
                scale_y_continuous( limits = c(0, 85)) +
                # Change the title of the plot for each year
                # Returns a character vector containing a formatted combination 
                # of text and variable values
                ggtitle(sprintf("Dietary supplements for age %d", input$age)) +
                theme_bw()
        })
        
        #next make body measures plot
        
        output$bmPlot = renderPlot({
            # Filter to measure specified from dropdown menu
            if(input$body_measure=="BMI"){
                column <- filtered$BMXBMI
            }
            else if(input$body_measure=="Weight (kg)"){
                column <- filtered$BMXWT
            }
            else if(input$body_measure=="Waist circumference (cm)"){
                column <- filtered$BMXWAIST
            }
            else{
                column <- filtered$BPXPLS
            }
            filtered %>% 
                ggplot(aes(x = INDFMPIR, y = column, color=Sex)) +
                geom_smooth() + xlab("Ratio of family income to poverty line") + ylab(input$body_measure) + ggtitle(sprintf("Comparing ratio of family income to poverty vs. %s", input$body_measure)) + labs(color="Sex")
        })
        #lastly make calorie BMI Plot
        output$kcalPlot = renderPlot({
            if(input$weightgoals == "More") {
                f1 <- filtered %>% filter(WHQ040 == "1")
            }
            else if(input$weightgoals == "Less"){
                f1<- filtered %>% filter(WHQ040 == "2")
            }
            else if(input$weightgoals == "The same"){
                f1 <- filtered %>% filter(WHQ040 == "3")
            }
            else{
                f1 <- filtered
            }
            
            
            #make third plot 
            f1%>% ggplot(aes(x=DR1TKCAL, y=BMXBMI,col=DSDCOUNT)) + geom_point(alpha=0.1) + ggtitle("Calories consumed and BMI") + xlab("Calories consumed (square root scale)") + ylab("BMI (square root scale)") + scale_x_sqrt(limits=c(0, 15000)) +scale_y_sqrt(limits=c(0, 85)) + labs(col="Number of dietary supplements taken")
        })
        
    }

shinyApp(ui=ui, server=server)