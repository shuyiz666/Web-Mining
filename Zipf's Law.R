rm(list=ls());cat("\014")
load('Nresgroup.Dtm.RData')
library(tm)

# Take Y to be the natural logarithm of the Frequency
freq <- colSums(dtm) # Term frequencies
ord <- order(freq, decreasing = TRUE) # Indices of frequencies order
frequency <- freq[ord]
y <- log(frequency)
Freq.Percent <- frequency/sum(frequency)*100

# Take X to be the natural logarithm of the Rank (the order from most to list popular words)
TotalNum_Words <- dim(dtm)[2]
rank <- 1:TotalNum_Words
x <- log(rank)

data <- data.frame(X=x,Y=y)
plot(data,col='red')

# fitting linear model
model <- lm(Y~X, data)
model$coefficients
s <- round(model$coefficients[2],4)
predictedY <- predict(model,data) # regression-predicted values from the model
lines(data$X,predictedY,col='blue',pch=4)

Title <- paste0("Zipf's law(s=",s,") for Newsgroups1 & newsgroup2")
title(Title)

# using tm package
Zipf_plot(dtm,main=Title,type = 'p',col='red')

# Plot Percentage of all  words  vs unique words
xx <- rank
yy <- cumsum(Freq.Percent)

data1 <- data.frame(X=xx, Y=yy)
plot(data1,col='red',xlab = 'Rank of Unique words', ylab = 'Cumulative Percent(%)')
grid(nx=NULL,ny=NULL,col='lightgray',lty='dotted')

# what is the percentage of single words
ix <-which(frequency<2) # indices of Single words
Single.Words <- sum(frequency[ix])/TotalNum_Words*100 # Percent of words appearing only once
Single.Words

# check is half of any text is 50 to 100 same words
Title1 <- 'The 100 most frequent words comprise 50% of the entire text!'
Title2 <- 'Half(50%) of ANY text is the 100 same (most frequent) words!'
Title <- paste(Title,Title2, sep='\n')
plot(data1[1:100,], col="red",  xlab ="Rank", ylab = "Cumulative Percent(%)" )
grid(nx=NULL,ny=NULL,col='lightgrey',lty='dotted')
title(main=Title,sub='The 100 Most Frequent Words')
