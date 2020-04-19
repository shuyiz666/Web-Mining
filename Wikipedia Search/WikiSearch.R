# Wikipedia Search
library(tm)
library(stringi)
library(WikipediR)
library(wordcloud)

SearchWiki <- function(titles){
  articles <- lapply(titles,function(i) page_content("en","wikipedia",page_name = i, as_wikitext = TRUE)$parse$wikitext)
  docs <- Corpus(VectorSource(articles)) # Get Web Pages' Corpus
  remove(articles)
  
  # Text analysis - Preprocessing
  transform.words <- content_transformer(function(x, from, to) gsub(from, to, x))
  temp <- tm_map(docs, transform.words,"<.+?>"," ")
  temp <- tm_map(temp, transform.words,"\t"," ")
  temp <- tm_map(temp, content_transformer(tolower)) # conversion to lowercase
  temp <- tm_map(temp, stripWhitespace)
  temp <- tm_map(temp, removeWords, stopwords("english"))
  temp <- tm_map(temp, removePunctuation)
  temp <- tm_map(temp, stemDocument, language = "english") # Perform Stemming
  remove(docs)
  
  # Create Dtm
  dtm <- DocumentTermMatrix(temp)
  dtm <- removeSparseTerms(dtm,0.4)
  dtm$dimnames$Docs <- titles
  
  freq <- colSums(as.matrix(dtm))
  ord <- sort(freq, decreasing = TRUE)[1:50]
  wordcloud1 <- wordcloud(names(ord), ord, colors=brewer.pal(8, "Dark2"))
}

