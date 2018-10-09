#source"https://blog.csdn.net/stat_elliott/article/details/42458487"
#"https://github.com/maoqyhz"
#"http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know"

library(tm)
library(SnowballC)
library(RColorBrewer)
library(wordcloud)
library(readr)
library(lm)
library(rvest)

w.web <-read_html("https://financesonline.com/top-10-most-expensive-red-wines-in-the-world-cabernet-sauvignon-tops-the-list/")
w.con <- w.web %>% html_nodes(".bg-title span , p span") %>% html_text()
w.doc <- Corpus(VectorSource(w.con))
inspect(w.doc)

w.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
w.doc <- tm_map(w.doc, removePunctuation )
w.doc <- tm_map(w.doc, removeWords, stopwords("english") )
w.doc <- tm_map(w.doc, stripWhitespace )
w.doc <- tm_map (w.doc, stemDocument)


dtm<- TermDocumentMatrix(w.docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)


set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 3,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
