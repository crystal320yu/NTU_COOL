library(RColorBrewer)
library(wordcloud)
library(readr)
library(xml2)
library(rvest)
library(NLP)
library(tm)

#1.藉由文字雲比較不同廠牌的卸妝(油、乳、水)
#2.針對感覺評價最好的，查看使用者膚質類型

#建立for迴圈，使用influenster.com的評論資料  
#爬取20頁"philosophy purity made simple one-step facial cleanser"的使用心得

for (j in 2:20)
{
  phwash = read_html(paste('https://www.influenster.com/reviews/philosophy-purity-made-simple-one-step-facial-cleanser?review_page=',j, sep=''))
  results <- (phwash %>% html_nodes('.review-author-user-profile , .review-text')%>% html_text())
  phwash.doc <- Corpus(VectorSource(results))
  
  f.results <- (phwash %>% html_nodes('.review-author-user-profile')%>% html_text())
  face.doc <- Corpus(VectorSource(f.results))
  inspect(face.doc)
}

#整理資料:去除標點符號、去除多餘空格、取詞幹、停止詞集、去詞一些我覺得詞頻太多的字
#使用tm包以外的函數，需要用content_transformer()“包”起來，再被tm_map()調用。
clean <- {
  phwash.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  phwash.doc <- tm_map(phwash.doc, removePunctuation )
  phwash.doc <- tm_map(phwash.doc, removeWords, stopwords("english") )
  phwash.doc <- tm_map(phwash.doc, stripWhitespace )
  phwash.doc <- tm_map (phwash.doc, stemDocument)
  phwash.doc <- tm_map (phwash.doc, removeWords, c("cleanser", "use","this","remove","<e2>"))
  
}

#運用TermDocumentMatrix建立詞頻矩陣
ptdm<- TermDocumentMatrix(phwash.doc)
pm <- as.matrix(ptdm)
pv <- sort(rowSums(pm),decreasing=TRUE)
pd <- data.frame(word = names(pv),freq=pv)

#head出現詞頻出現最多的，用ggplot做出長條圖。
freq <- rowSums(as.matrix(ptdm))
pd.select<-head(sort(freq, decreasing = T))
d.select <- head(pd)
library(ggplot2)
ggplot(d.select, aes(x = word, y = freq)) + geom_bar(stat = "identity") 

#做出文字雲
set.seed(1234)
wordcloud(words = pd$word, freq = pd$freq, min.freq = 3, max.freq = 100,
          max.words=300, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

for (j in 2:20){
  phwash = read_html(paste('https://www.influenster.com/reviews/philosophy-purity-made-simple-one-step-facial-cleanser?review_page=',j, sep=''))
  f.results <- (phwash %>% html_nodes('.review-author-user-profile')%>% html_text())
  face.doc <- Corpus(VectorSource(f.results))
  inspect(face.doc)
}


clean <- {
  face.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  face.doc <- tm_map(face.doc, removePunctuation )
  face.doc <- tm_map(face.doc, removeWords, stopwords("english") )
  face.doc <- tm_map(face.doc, stripWhitespace )
  face.doc <- tm_map (face.doc, stemDocument)
  face.doc <- tm_map (face.doc, removeWords, c("cleanser", "use","this","this","remove","<e2>"))
  
}

fdtm<- TermDocumentMatrix(face.doc)
fm <- as.matrix(fdtm)
fv <- sort(rowSums(fm),decreasing=TRUE)
fd <- data.frame(word = names(fv),freq=fv)

set.seed(123)
wordcloud(words = fd$word, freq = fd$freq, min.freq = 2, max.freq = 100,
          max.words=300, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

