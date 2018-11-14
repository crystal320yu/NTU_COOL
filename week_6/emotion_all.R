library(tidyr)
library(tidytext)
library(widyr)
library(dplyr)
library(rvest)
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
library(stringr)

#將CNN"politics"版第一頁每篇新聞html抓下來，存成txt檔
k <- readLines("file:///C:/Users/user/Desktop/NTU_COOL/week_5/news.txt" )


urlList <- list()
for(i in 2:84){
  url <- k[i] %>% as.character()
  urlList <- rbind(urlList, url)
}

urlList = unique(urlList)
text1 = news.doc
news.doc <- list()
for(url in urlList[2:55])
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
cleandf <- data_frame(clean)
colnames(cleandf)<- ("text")
cleandf$text=gsub("&amp", "", cleandf$text)
cleandf$text = gsub("&amp", "", cleandf$text)
cleandf$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", cleandf$text)
cleandf$text = gsub("@\\w+", "", cleandf$text)
cleandf$text = gsub("[[:punct:]]", "", cleandf$text)
cleandf$text = gsub("[[:digit:]]", "", cleandf$text)
cleandf$text = gsub("http\\w+", "", cleandf$text)
cleandf$text = gsub("[ \t]{2,}", "", cleandf$text)
cleandf$text = gsub("^\\s+|\\s+$", "", cleandf$text)
cleandf$text <- iconv(cleandf$text, "UTF-8", "ASCII", sub="")

#creat emotion classification bar
# summarize "nrc"
emotions <- cleandf %>% right_join(get_sentiments("nrc"), by=c("text"="word"))%>%
  filter(!is.na(sentiment)) %>%
  count(sentiment, sort = TRUE)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

library(plotly)
p <- plot_ly(emotions, x=emotions$sentiment, y=emotions$n, type="bar", color=emotions$sentiment) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Emotion Type for politics news")
p
api_create(p,filename="Sentimentanalysis")

cleanText = c()
for (t in clean)
{
  cleanText <- append(cleanText,t)
}
cleanText$language = NULL

GOPTexts = c()
for (count in str_count(cleanText, "Obama"))
{
  GOPTexts = append(GOPTexts, count != 0)
}

l = str_count(cleanText, "Democratic")
for (i in 1:54)
{
  GOPTexts[i] = GOPTexts[i] || l[i]
}
GOPTexts

selectGOP = cleandf
GOP_doc = selectGOP[GOPTexts,]
GOP_doc= as.data.frame(GOP_doc)
colnames(GOP_doc)<- "GOPtext"
GOP_emo = GOP_doc %>% right_join(get_sentiments("nrc"), by=c("GOPtext"="word")) 
GOP_sum <- GOP_emo %>% count(sentiment, sort=TRUE)


#word cloud

wordcloud_politics = c(
  paste(cleandf$text[emotions$anger > 0], collapse=" "),
  paste(cleandf$text[emotions$anticipation > 0], collapse=" "),
  paste(cleandf$text[emotions$disgust > 0], collapse=" "),
  paste(cleandf$text[emotions$fear > 0], collapse=" "),
  paste(cleandf$text[emotions$joy > 0], collapse=" "),
  paste(cleandf$text[emotions$sadness > 0], collapse=" "),
  paste(cleandf$text[emotions$surprise > 0], collapse=" "),
  paste(cleandf$text[emotions$trust > 0], collapse=" ")
)

# create corpus
corpus = Corpus(VectorSource(cleandf$text))

# remove punctuation, convert every word in lower case and remove stop words
cleancorpus <-{
  cnn.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  corpus <- tm_map(clean, removePunctuation )
  corpus <- tm_map(clean, removeWords, stopwords("english") )
  corpus <- tm_map(clean, stripWhitespace )
  corpus <- tm_map(clean, removeNumbers )
  corpus <- tm_map (clean, stemDocument)
}

# create document term matrix

tdm = TermDocumentMatrix(corpus)

# convert as matrix
tdm = as.matrix(tdm)
tdmnew <- tdm[nchar(rownames(tdm)) < 11,]

# column name binding
colnames(tdm) = c('anger', 'anticipation', 'disgust', 'fear', 'joy', 'sadness', 'surprise', 'trust')
colnames(tdmnew) <- colnames(tdm)
comparison.cloud(tdmnew, random.order=FALSE,
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC", "green", "orange", "blue", "brown"),
                 title.size=1, max.words=250, scale=c(2.5, 0.4),rot.per=0.4)




cleanc <-{
  cnn.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  clean <- tm_map(clean, removePunctuation )
  clean <- tm_map(clean, removeWords, stopwords("english") )
  clean <- tm_map(clean, stripWhitespace )
  clean <- tm_map(clean, removeNumbers )
  clean <- tm_map (clean, stemDocument)
}
