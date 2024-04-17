library(shiny)

api_url <- "http://127.0.0.1:8080/predict"
log <- log4r::logger()

ui <- fluidPage(
  titlePanel("Penguin Mass Predictor"),
  
  # Model input values
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bill_length",
        "Bill Length (mm)",
        min = 30,
        max = 60,
        value = 45,
        step = 0.1
      ),
      selectInput(
        "sex",
        "Sex",
        c("Male", "Female")
      ),
      selectInput(
        "species",
        "Species",
        c("Adelie", "Chinstrap", "Gentoo")
      ),
      # Get model predictions
      actionButton(
        "predict",
        "Predict"
      )
    ),
    
    mainPanel(
      h2("Penguin Parameters"),
      verbatimTextOutput("vals"),
      h2("Predicted Penguin Mass (g)"),
      textOutput("pred")
    )
  )
)

server <- function(input, output) {
  log4r::info(log, "App Started")
  
  vals <- reactive({
    list(
      bill_length_mm = input$bill_length,
      species_Chinstrap = input$species == "Chinstrap",
      species_Gentoo = input$species == "Gentoo",
      sex_male = input$sex == "Male"
    )
  })
  
  pred <- eventReactive(input$predict, {
    log4r::info(log, "Prediction Requested")
    
    # Prepare and perform the request
    r <- tryCatch({
      req <- httr2::request(api_url) |>
        httr2::req_body_json(vals()) |>
        httr2::req_perform()
      req
    }, error = function(e) {
      log4r::error(log, sprintf("Error performing HTTP request: %s", e$message))
      NULL  # Return NULL on error to handle it gracefully
    })
    
    # Check if the request was successful
    if (is.null(r) || httr2::resp_is_error(r)) {
      # Log detailed error information
      if (!is.null(r)) {
        status_code <- httr2::resp_status_code(r)
        error_details <- httr2::resp_body_text(r)
        log4r::error(log, sprintf("HTTP Error %d: %s", status_code, error_details))
      }
      
      return("Error occurred, check logs for details.")
    }
    
    log4r::info(log, "Prediction Returned")
    httr2::resp_body_json(r)
  }, ignoreInit = TRUE)
  
  output$pred <- renderText({
    result <- pred()
    if (is.character(result) && result == "Error occurred, check logs for details.") {
      result
    } else {
      result$predict[[1]]
    }
  })
  
  output$vals <- renderPrint(vals())
}

# Run the application
shinyApp(ui = ui, server = server)