#install.packages("jiebaR")
library(RColorBrewer)
library(wordcloud)
library(readr)
library(lm)
library(rvest)
library(tm)
library(NLP)

##建立for迴圈，爬取20頁"Kiehl's Ultra Facial Cleanser"的使用心得
for(h in 2:25){
wash.web =read_html(paste('https://www.influenster.com/reviews/kiehls-ultra-facial-cleanser?review_page=',h, sep=''))
wash.con <- (wash.web %>% html_nodes(".review-author-user-profile , .review-text") %>% html_text())
wash.doc <- Corpus(VectorSource(wash.con))
inspect(wash.doc)
}

cleanw <-{
wash.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
wash.doc <- tm_map(wash.doc, removePunctuation )
wash.doc <- tm_map(wash.doc, removeWords, stopwords("english") )
wash.doc <- tm_map(wash.doc, stripWhitespace )
wash.doc <- tm_map (wash.doc, stemDocument)
}

{
wtmd<- TermDocumentMatrix(wash.doc)
wm <- as.matrix(wtmd)
wv <- sort(rowSums(wm),decreasing=TRUE)
wd <- data.frame(word = names(wv),freq=wv)
}
head(wd, 10)


set.seed(12)
wordcloud(words = wd$word, freq = wd$freq, min.freq = 3,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
