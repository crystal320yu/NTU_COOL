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
library(rvest)

#將CNN"politics"版第一頁每篇新聞html抓下來，存成txt檔
k <- readLines("file:///C:/Users/user/Desktop/NTU_COOL/week_5/news.txt" )


urlList <- list()
for(i in 2:99){
  url <- k[i] %>% as.character()
  urlList <- rbind(urlList, url)
}

urlList = unique(urlList)
text1 = news.doc
news.doc <- list()
for(url in urlList[2:56])
{
  print(url)
  html <- read_html(url) %>% html_nodes(".zn-body__paragraph") %>% html_text()
  texts = ""
  for (text in html)
  {
    texts = paste(texts, text)
  }
  news.doc <- rbind( news.doc, as.matrix(texts, sep=''))
  print("sleeping...")
  Sys.sleep(3)
  print("Im awake")
}

clean <- as.matrix(news.doc) 
clean <- as.character(clean)
clean <- Corpus(VectorSource(clean))



cleanc <-{
  cnn.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  clean <- tm_map(clean, removePunctuation )
  clean <- tm_map(clean, removeWords, stopwords("english") )
  clean <- tm_map(clean, stripWhitespace )
  clean <- tm_map(clean, removeNumbers )
  clean <- tm_map (clean, stemDocument)
}


d.corpus <- Corpus(VectorSource(clean))
tdm <- TermDocumentMatrix(clean)
inspect(tdm)

#tf
tf <- (as.matrix(tdm))
#idf
idf <- log( ncol(tf) / ( 1 + rowSums(tf != 0) ) ) 

tf <- apply(tdm, 2, sum) # term frequency
idf <- function(word_doc){ log2( (length(word_doc)+1) / nnzero(word_doc) ) }
idf <- apply(tdm, 1, idf)
doc.tfidf <- as.matrix(tdm)
for(i in 1:nrow(tdm)){
  for(j in 1:ncol(tdm)){
    doc.tfidf[i,j] <- (doc.tfidf[i,j] / tf[j]) * idf[i]
  }
}


cleanText = c()
for (t in clean)
{
  cleanText <- append(cleanText,t)
}
cleanText$language = NULL

GOPTexts = c()
for (count in str_count(cleanText, "Trump"))
{
  GOPTexts = append(GOPTexts, count != 0)
}

l = str_count(cleanText, "GOP")
for (i in 1:54)
{
  GOPTexts[i] = GOPTexts[i] || l[i]
}

newTFIDF = as.data.frame(doc.tfidf) 
select <- newTFIDF[,GOPTexts]
sums = rowSums(x=select)
selectr <-as.data.frame(sums)
selectr <- as.data.frame(selectr)
colnames(selectr)
selectt <- select$Term
ggplot(selectr, aes(y="sum")) + geom_bar(stat='identity',colour="white",  fill= "blue")
sums[0]

