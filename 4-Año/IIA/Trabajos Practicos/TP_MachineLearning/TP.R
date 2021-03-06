library(caret)
library(rpart)
library(rpart.plot)
library(e1071)
library(rattle)

zooDataset <- read.csv('Dataset/zoo.data')
zooDataset[,"type"] <- as.factor(zooDataset[,"type"])
zooDataset <- zooDataset[2:18]

indexData <- createFolds(t(zooDataset[,"type"]), k=5)
zooDatasetTest <- zooDataset[indexData[[2]],]
zooDatasetTrain <- zooDataset[setdiff(seq(1:dim(zooDataset)[1]), indexData[[2]]),]

# hair+feathers+eggs+milk+airborne+aquatic+predator+toothed+backbone+breathes+venomous+fins+legs+tail+domestic+catsize

# fit1 <- rpart(type ~ hair + eggs + milk, data=zooDatasetTrain, parms=list(split = 'information'))
# fit2 <- rpart(type ~ milk+airborne+aquatic+predator+toothed+backbone+breathes+venomous+fins+legs+tail+domestic, data=zooDatasetTrain, parms=list(split = 'information'))
# fit2_gini <- rpart(type ~ milk+airborne+aquatic+predator+toothed+backbone+breathes+venomous+fins+legs+tail+domestic, data=zooDatasetTrain, parms=list(split = 'gini'))
# fit3 <- rpart(type ~ hair+milk+airborne+aquatic+predator+toothed+backbone+breathes+venomous+fins+legs+tail+domestic, data=zooDatasetTrain, parms=list(split = 'information'))
# fit4 <- rpart(type ~ hair+feathers+milk+predator+toothed+backbone+fins, data=zooDatasetTrain, parms=list(split = 'gini'))
# fit <- rpart(type ~ feathers+milk+airborne+backbone+fins+tail, data=zooDatasetTrain, parms=list(split = 'gini'))

fitAll <- rpart(type ~ ., data=zooDatasetTrain, parms=list(split = 'gini'))
# fitPerfect <- rpart(type ~ feathers+milk+backbone+fins, data=zooDatasetTrain, parms=list(split = 'gini'))

fitAll_info <- rpart(type ~ ., data=zooDatasetTrain, parms=list(split = 'information'))
# fitPerfect_info <- rpart(type ~ feathers+milk+backbone+fins, data=zooDatasetTrain, parms=list(split = 'information'))


fitAll_pruning <- prune(fitAll, cp=0.1)

# fancyRpartPlot(fit1, caption="fit1")
# fancyRpartPlot(fit2, caption="fit2")
# fancyRpartPlot(fit2_gini, caption="fit2_gini")
# fancyRpartPlot(fit3, caption="fit3")
# fancyRpartPlot(fit4, caption="fit4")
# fancyRpartPlot(fit, caption="fit")
fancyRpartPlot(fitAll, caption="fitAll_gini")
fancyRpartPlot(fitAll_info, caption="fitAll_info")
# fancyRpartPlot(fitPerfect, caption="fitPerfect")
fancyRpartPlot(fitAll_pruning, caption="fitAll_pruning")


# predictZoo1 <- predict(fit1, zooDatasetTest[,-18], type = 'class') # acc = .6
# confusionMatrix(predictZoo1, zooDatasetTest[,"type"])
# 
# predictZoo2 <- predict(fit2, zooDatasetTest[,-18], type = 'class')
# confusionMatrix(predictZoo2, zooDatasetTest[,"type"])
# 
# predictZoo2_gini <- predict(fit2_gini, zooDatasetTest[,-18], type = 'class')
# confusionMatrix(predictZoo2_gini, zooDatasetTest[,"type"])
# 
# predictZoo3 <- predict(fit3, zooDatasetTest[,-18], type = 'class')
# confusionMatrix(predictZoo2, zooDatasetTest[,"type"])
# 
# predictZoo <- predict(fit, zooDatasetTest[,-18], type = 'class')
# confusionMatrix(predictZoo, zooDatasetTest[,"type"])
# 
# predictZoo4 <- predict(fit4, zooDatasetTest[,-18], type = 'class')
# confusionMatrix(predictZoo4, zooDatasetTest[,"type"])

predictZooAll <- predict(fitAll, zooDatasetTest[,-18], type = 'class') # acc = .9
confusionMatrix(predictZooAll, zooDatasetTest[,"type"], mode="everything")

# predictZooPerfect <- predict(fitPerfect, zooDatasetTest[,-18], type = 'class') # acc = .9
# confusionMatrix(predictZooPerfect, zooDatasetTest[,"type"])

predictZooAll_info <- predict(fitAll_info, zooDatasetTest[,-18], type = 'class') # acc = .9
confusionMatrix(predictZooAll_info, zooDatasetTest[,"type"], mode="everything")

# predictZooPerfect_info <- predict(fitPerfect_info, zooDatasetTest[,-18], type = 'class') # acc = .9
# confusionMatrix(predictZooPerfect_info, zooDatasetTest[,"type"])

predictZooAll_pruning <- predict(fitAll_pruning, zooDatasetTest[,-18], type = 'class') # acc = .9
confusionMatrix(predictZooAll_pruning, zooDatasetTest[,"type"], mode="everything")


# predictZoo <- predict(fitPerfect, zooDataset[,-18], type = 'class')
# confusionMatrix(predictZoo, zooDataset[,"type"])

# ======================================= Plot CMatrix =================================================================
# library(dplyr)
# 
# table <- data.frame(confusionMatrix(predictZooAll_info, zooDatasetTest[,"type"])$table)
# # 
# plotTable <- table %>%
#   mutate(goodbad = ifelse(table$Prediction == table$Reference, "good", "bad")) %>%
#   group_by(Reference) %>%
#   mutate(prop = Freq/sum(Freq))
# # 
# ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad, alpha = prop)) +
#   geom_tile() +
#   geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
#   scale_fill_manual(values = c(good = "green", bad = "red")) +
#   theme_bw() +
#   xlim(rev(levels(table$Reference)))
# ======================================================================================================================
