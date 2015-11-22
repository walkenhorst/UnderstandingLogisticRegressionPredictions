shinyUI(fluidPage(
  titlePanel("Understanding Logistic Regression Predictions"),
  fluidRow(
    column(4,
      numericInput('threshold', 'Adjust the threshold to see the effect on the predictions made by the model',value = 0.5, min = 0, max = 1, step = 0.01),
      p("A logistic regression model was fitted to the titanic survivors training data from Kaggle."),
      p("This model was used to predict survival probability for a hold-out sample from the training data."),
      p("The ROC curve and other statistics show how adjusting the probability threshold for survival changes the performance of the model. Ie. changing the threshold changes the accuracy, sensitivity, specificity, positive predictive value (PPV) and negative predictive value (NPV).")
    ),
    column(8,
      p("This tool interactively illustrates the effect that changes to a probability threshold (cut-off) have on predictions made by a logistic regression model."),
      plotOutput('RocCurve'),
      fluidRow(
        h4("Confusion Matrix"),
        column(8,
          fluidRow(column(3,p("")),column(3,p("Survival")),column(3,p("Non-survival")),column(3,p("Totals"))),
          fluidRow(
            column(3,p("Predicted survival")),column(3,verbatimTextOutput("TP")),column(3,verbatimTextOutput("FP")),column(3,verbatimTextOutput("PosTotal"))
          ),
          fluidRow(
            column(3,p("Predicted non-survival")),column(3,verbatimTextOutput("FN")),column(3,verbatimTextOutput("TN")),column(3,verbatimTextOutput("NegTotal"))
          ),
          fluidRow(
            column(3,p("Totals")),column(3,verbatimTextOutput("TrueTotal")),column(3,verbatimTextOutput("FalseTotal")),column(3,verbatimTextOutput("total"))
          )
        ),
        h4("Statistics"),
        column(4,
          fluidRow(column(6,p("Accuracy")), column(6,verbatimTextOutput("acc"))),
          fluidRow(column(6,p("Specificity")), column(6,verbatimTextOutput("spec"))),
          fluidRow(column(6,p("Sensitivity")), column(6,verbatimTextOutput("sens"))),
          fluidRow(column(6,p("PPV")), column(6,verbatimTextOutput("ppv"))),
          fluidRow(column(6,p("NPV")), column(6,verbatimTextOutput("npv")))
        )
      )
    )
  )
))