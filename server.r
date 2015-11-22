library(caret)
library(pROC)
#uses data from the Kaggle titanic competition": https://www.kaggle.com/c/titanic/data
titanicTrain = read.csv("titanic train.csv")
#fix up some data errors
titanicTrain$Survived = as.factor(titanicTrain$Survived)
#split the data for training and testing
trainBool = createDataPartition(titanicTrain$Survived, p=0.7, list=FALSE)
trainSet = titanicTrain[trainBool,]
testSet = titanicTrain[-trainBool,]
#fit the model
fit = glm(Survived~Pclass+Sex+SibSp, data=trainSet, family="binomial")
#predict the test set
predTest = predict(fit,newdata=testSet, type="response")
rocObj = roc(testSet$Survived, predTest)
auc = auc(rocObj)

shinyServer(
  function(input, output) {
    predictions = reactive({factor(as.numeric((predTest>as.numeric(input$threshold))), levels=c("0","1"))})
    TP = reactive({sum(testSet$Survived == 1 & predictions() == 1)})
    FP = reactive({sum(testSet$Survived == 0 & predictions() == 1)})
    TN = reactive({sum(testSet$Survived == 0 & predictions() == 0)})
    FN = reactive({sum(testSet$Survived == 1 & predictions() == 0)})
    prevalence = reactive({sum(testSet$Survived == 1)/length(testSet$Survived)})
    
    PosTotal = reactive({sum(predictions() == 1)})
    NegTotal = reactive({sum(predictions() == 0)})
    TrueTotal = reactive({sum(testSet$Survived == 1)})
    FalseTotal = reactive({sum(testSet$Survived == 0)})
    total = reactive({length(testSet$Survived)})
    
    sens = reactive({TP()/TrueTotal()})
    spec = reactive({TN()/FalseTotal()})
    ppv = reactive({TP()/PosTotal()})
    npv = reactive({TN()/FalseTotal()})
    output$RocCurve <- renderPlot({
      plot(rocObj)#, legacy.axes=TRUE)
      points(x=spec(), y=sens(), col="red", pch=19, cex=2)
    })
    # get the threshold input by the user on the UI
    output$TP = renderText({TP()})
    output$FP = renderText({FP()})
    output$TN = renderText({TN()})
    output$FN = renderText({FN()})
    output$PosTotal = reactive({PosTotal()})
    output$NegTotal = reactive({NegTotal()})
    output$TrueTotal = reactive({TrueTotal()})
    output$FalseTotal = reactive({FalseTotal()})
    output$total = reactive({total()})
    
    output$spec = renderText({round(spec(),4)})
    output$sens = renderText({round(sens(),4)})
    output$ppv = renderText({round(ppv(),4)})
    output$npv = renderText({round(npv(),4)})
    output$acc = renderText({round(sum(TP()+TN())/total(),4)})

  }
)