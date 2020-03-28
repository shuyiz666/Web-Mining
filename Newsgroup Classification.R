rm(list=ls());cat("\014")
library(tm)
library(class)

Docs.pth <- system.file("texts","20Newsgroups",package = "tm")

Temp1 <- DirSource(file.path(Docs.pth,'20news-bydate-train/sci.space'))
Doc1.Train <- Corpus(URISource(Temp1$filelist[1:100]),readerControl = list(reader=readPlain))

Temp2 <- DirSource(file.path(Docs.pth,'20news-bydate-test/sci.space'))
Doc1.Test <- Corpus(URISource(Temp2$filelist[1:100]),readerControl = list(reader=readPlain))

Temp3 <- DirSource(file.path(Docs.pth,'20news-bydate-train/rec.autos'))
Doc2.Train <-Corpus(URISource(Temp3$filelist[1:100]),readerControl = list(reader=readPlain))
  
Temp4 <- DirSource(file.path(Docs.pth,'20news-bydate-test/rec.autos'))
Doc2.Test <-Corpus(URISource(Temp4$filelist[1:100]),readerControl = list(reader=readPlain))

# Obtain the merged Corpus
doc <- c(Doc1.Train,Doc1.Test,Doc2.Train,Doc2.Test)

# Preprocessing
corpus.temp <- tm_map(doc, removePunctuation) # Remove Punctuation
corpus.temp <- tm_map(corpus.temp, stemDocument, language = "english")# Perform Stemming

# Create the Document-Term Matrix
dtm <- as.matrix(DocumentTermMatrix(corpus.temp,control=list(wordLengths=c(2,Inf), bounds=list(global=c(5,Inf))))) 

#  Split the Document-Term Matrix into proper test/train row ranges
train.doc <- dtm[c(201:300,1:100),]
test.doc <- dtm[c(301:400,101:200),]

Tags <- factor(c(rep('Positive',100),rep('Negative',100)),levels=c("Positive", "Negative"))
table(Tags)

# knn
set.seed(0)
prob.test<- knn(train.doc, test.doc, Tags, k = 2, prob=TRUE)

# Display Classification Results
a <- 1:length(prob.test)
b <- levels(prob.test)[prob.test]
c <- attributes(prob.test)$prob
d <- prob.test == Tags
result <- data.frame(Doc=a, Predict=b,Prob=c,correct = d)
result

# the percentage of correct (TRUE) classifications
correct_classification <- sum(prob.test==Tags)/length(Tags)
paste(round(100*correct_classification, 2), "%", sep="")

# Estimate the effectiveness of your classification
# Consider " Rec" as Positive and " Sci" as Negative
RecClassified <- (prob.test==Tags)[1:100] # Classified as “Rec" (Positive)
TP <- sum(RecClassified=="TRUE") # Actual “Rec" classified as “Rec"
FN <- sum(RecClassified=="FALSE") # Actual “Rec" classified as “Sci"

SciClassified <- (prob.test==Tags)[101:200] # Classified as “Sci" (Negative)
TN <- sum(SciClassified=="TRUE") # Actual “Sci" classified as “Sci"
FP <- sum(SciClassified=="FALSE") # Actual “Sci" classified as “Rec"

# confusion matrix
AutoCM <- table(prob.test, Tags)
CM <- data.frame(Rec=c(TP,FN), Sci=c(FP,TN),row.names=c("Rec","Sci"))

# Precision
Precision <- TP/(TP+FP)
paste(round(100*Precision, 2), "%", sep="")


# Recall
Recall <- TP/(TP+FN)
paste(round(100*Recall, 2), "%", sep="")


# F-score
F_score <- 2*Precision*Recall/(Precision+Recall)
paste(round(100*F_score, 2), "%", sep="")
