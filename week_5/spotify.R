
library(xml2)
library(rvest)
library(NLP)
library(tm)
library(tmcn)
library(htmltools)
library(readr)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(Matrix)

link <- url("https://www.sitejabber.com/reviews/spotify.com")
spotifyurl <- read_html(link)
spotdoc <- (spotifyurl %>% html_nodes('.review_content') %>% html_text() %>% as.character())
applurl <- "https://www.sitejabber.com/reviews/itunes.com"
appldoc <- ( read_html(applurl)%>% html_nodes(".review_content")%>%  html_text()%>% as.character())
spotdoc <- Corpus( VectorSource(spotdoc) )

{
  spot.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  spotdoc <- tm_map(spotdoc, removePunctuation )
  spotdoc <- tm_map(spotdoc, removeWords, stopwords("english") )
  spotdoc <- tm_map(spotdoc, stripWhitespace )
  spotdoc <- tm_map (spotdoc, stemDocument)
  spotdoc <- tm_map(spotdoc, removeNumbers)
}

appldoc <- Corpus( VectorSource(appldoc) )

{
  applspace <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  appldoc <- tm_map(appldoc, removePunctuation )
  appldoc <- tm_map(appldoc, removeWords, stopwords("english") )
  appldoc <- tm_map(appldoc, stripWhitespace )
  appldoc <- tm_map (appldoc, stemDocument)
  appldoc <- tm_map(appldoc, removeNumbers)
  
}

atdm<- TermDocumentMatrix(appldoc)
am <- as.matrix(atdm)
av <- sort(rowSums(am),decreasing=TRUE)
ad <- data.frame(word = names(av),freq=av)

stdm<- TermDocumentMatrix(spotdoc)
sm <- as.matrix(stdm)
sv <- sort(rowSums(sm),decreasing=TRUE)
sd <- data.frame(word = names(sv),freq=sv)


# print
( tf <- (as.matrix(atdm)))
head(tf[order(-tf[,1]),])
head(tf[order(-tf[,2]),])

#
v <- sort(rowSums(tf), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
wordcloud(d$word, d$freq, min.freq = 100, random.order = F, ordered.colors = F, 
          colors = rainbow(length(row.names(tf))))



tf <- apply(tdm, 2, sum) # term frequency
idf <- function(word_doc){ log2( (length(word_doc)+1) / nnzero(word_doc) ) }
idf <- apply(tdm, 1, idf)
doc.tfidf <- as.matrix(tdm)
for(i in 1:nrow(tdm)){
  for(j in 1:ncol(tdm)){
    doc.tfidf[i,j] <- (doc.tfidf[i,j] / tf[j]) * idf[i]
  }
}


df.tfidf <- as.data.frame(doc.tfidf)
colnames(df.tfidf) = c( "republic","symposium")
h1<-(df.tfidf[order(-df.tfidf[,1]),])
h2<-(df.tfidf[order(-df.tfidf[,2]),])
h1[1:10,]
h2[1:10,]