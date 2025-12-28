library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
data <- read.csv(url, sep = ";")

colnames(data) <- c("Fixed_Acidity", "Volatile_Acidity", "Citric_Acid", 
                    "Residual_Sugar", "Chlorides", "Free_Sulfur", 
                    "Total_Sulfur", "Density", "pH", "Sulphates", 
                    "Alcohol_Vol", "Sensory_Score") 

ui <- fluidPage(
  
  titlePanel("Sensory Data Analysis & Decision Support Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Filter Panelists / Samples"),
      helpText("Simulate filtering samples based on chemical properties to predict sensory performance."),
      
      # Slider 1: Alcohol
      sliderInput("alcohol",
                  "Alcohol Volume (%):",
                  min = min(data$Alcohol_Vol),
                  max = max(data$Alcohol_Vol),
                  value = c(9, 11)),
      
      # Slider 2: Sugar
      sliderInput("sugar",
                  "Residual Sugar (g/L):",
                  min = min(data$Residual_Sugar),
                  max = 10,
                  value = c(1, 5)),
      
      hr(),
      h5("Decision Threshold"),
      numericInput("threshold", "Minimum Acceptable Sensory Score (0-10):", value = 6, min = 0, max = 10)
    ),
    
    mainPanel(
      tabsetPanel(
        # TAB 1: Visual Analysis
        tabPanel("Visual Correlation", 
                 plotOutput("scatterPlot"),
                 p(em("Insight: This visualizes how chemical intensity correlates with human sensory scoring."))
        ),
        
        # TAB 2: Decision Support 
        tabPanel("Decision Support", 
                 h3("Recommendation Engine"),
                 textOutput("decisionText"),
                 br(),
                 h4("Qualified Batches (Table)"),
                 DTOutput("table")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  # Reactive Data Filtering
  filtered_data <- reactive({
    data %>%
      filter(Alcohol_Vol >= input$alcohol[1],
             Alcohol_Vol <= input$alcohol[2],
             Residual_Sugar >= input$sugar[1],
             Residual_Sugar <= input$sugar[2])
  })
  
  # Plot Logic
  output$scatterPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Alcohol_Vol, y = Sensory_Score)) +
      geom_point(aes(color = as.factor(Sensory_Score)), size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", color = "black", se = FALSE) + # Trend line shows statistical rigor
      labs(title = "Impact of Alcohol Content on Sensory Score",
           x = "Alcohol Volume (%)",
           y = "Sensory Score (0-10)",
           color = "Score") +
      theme_minimal()
  })
  
  # Decision Logic
  output$decisionText <- renderText({
    n_pass <- nrow(filtered_data() %>% filter(Sensory_Score >= input$threshold))
    total <- nrow(filtered_data())
    ratio <- round((n_pass / total) * 100, 1)
    
    paste0("Based on current filters, ", n_pass, " out of ", total, 
           " samples meet the quality standard. ",
           "(Success Rate: ", ratio, "%). ",
           ifelse(ratio > 50, "✅ Go for Production.", "⚠️ Adjust Formulation."))
  })
  
  # Table Output
  output$table <- renderDT({
    filtered_data() %>%
      filter(Sensory_Score >= input$threshold) %>%
      select(Alcohol_Vol, Residual_Sugar, pH, Sensory_Score)
  })
}

shinyApp(ui = ui, server = server)