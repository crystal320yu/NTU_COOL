library(RColorBrewer)
library(wordcloud)
library(readr)
library(xml2)
library(rvest)
library(tm)
library(NLP)
library(jiebaR)

for (k in 2:10)
{
  white = read_html(paste('https://www.urcosme.com/tags/268/reviews?page=',k , sep=''))
  results <- (white %>% html_nodes('#append-reviews .uc-content-link')%>% html_text())
  white.doc <- Corpus(VectorSource(results))
  inspect(white.doc)
}
Sys.setlocale(category="LC_ALL", locale = "cht")
cc=worker()
