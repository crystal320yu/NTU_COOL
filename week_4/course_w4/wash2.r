library(RColorBrewer)
library(wordcloud)
library(readr)
library(xml2)
library(rvest)
library(tm)
library(NLP)

for (k in 2:10)
{
    wash = read_html(paste('https://www.totalbeauty.com/reviews/product/6304912/dhc-deep-cleansing-oil/reviews-p',k, '?sort=7', sep=''))
    results <- (wash %>% html_nodes('.reviewTitle , .smallContent')%>% html_text())
    wash.doc <- Corpus(VectorSource(results))
    inspect(wash.doc)
}

clean <- {
wash.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
wash.doc <- tm_map(wash.doc, removePunctuation )
wash.doc <- tm_map(wash.doc, removeWords, stopwords("english") )
wash.doc <- tm_map(wash.doc, stripWhitespace )
wash.doc <- tm_map (wash.doc, stemDocument)
wash.doc <- tm_map (wash.doc, removeWords, c("cleanser", "use","this","this","remove"))


}

dtm<- TermDocumentMatrix(wash.doc)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
d.select <- head(d, 15)

library(ggplot2)

ggplot(d.select, aes(x = word, y = freq)) + geom_bar(stat = "identity") 

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 3, max.freq = 100,
          max.words=300, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

