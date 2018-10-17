#http://www.gutenberg.org/cache/epub/13726/pg13726.txt
#http://ethen8181.github.io/machine-learning/clustering_old/tf_idf/tf_idf.html

library(xml2)
library(rvest)
library(NLP)
library(tm)
library(tmcn)
 library(httr)
library(readr)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(Matrix)
platurl <- "https://www.gutenberg.org/files/150/150.txt"
platdoc <- (read_html(platurl)%>% html_text())
symurl <- "http://www.gutenberg.org/cache/epub/1600/pg1600.txt"
symdoc <- ( read_html(symurl)%>% html_text())

platdoc <- Corpus( VectorSource(platdoc) )

{
  plat.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  platdoc <- tm_map(platdoc, removePunctuation )
  platdoc <- tm_map(platdoc, removeWords, stopwords("english") )
  platdoc <- tm_map(platdoc, stripWhitespace )
  platdoc <- tm_map (platdoc, stemDocument)
  platdoc <- tm_map(platdoc, removeNumbers)
}

symdoc <- Corpus( VectorSource(symdoc) )

{
  sym.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  symdoc <- tm_map(symdoc, removePunctuation )
  symdoc <- tm_map(symdoc, removeWords, stopwords("english") )
  symdoc <- tm_map(symdoc, stripWhitespace )
  symdoc <- tm_map (symdoc, stemDocument)
  symdoc <- tm_map(symdoc, removeNumbers)
  
}


select.docs <- c(platdoc$`content`, symdoc$`content`)
doc_corpus <- Corpus(VectorSource(select.docs) )

tdm <- TermDocumentMatrix(doc_corpus)
inspect(tdm)

# print
( tf <- (as.matrix(tdm)))
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
h110 <- h1[1:10,]
h2[1:10,]


library(ggplot2)
ggplot(df.tfidf, aes(y=republic)) +
  geom_histogram(show.legend = FALSE) +
  xlim(NA, 0.0009) 

library(ggplot2)
library(scales)
ggplot(df.tfidf, aes(x = proportion, y = "Plato", color = abs("Plato" - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Plato", x = NULL)

