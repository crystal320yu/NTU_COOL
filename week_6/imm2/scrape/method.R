immfile<- c("1.json","2.json","3.json","4.json","5.json","6.json","7.json","8.json","9.json","10.json","11.json","12.json","13.json","14.json","15.json","16.json","17.json","18.json","19.json","20.json","21.json","22.json","23.json")
Merged = ''
immmerge=list()
for(o in 1:22){
immfile <- paste0(o,".json")
test = fromJSON(file =immfile)
Title = test$Title
Content = as.data.frame(test$Content)
for (i in 1:length(Content))
{
  Merged = paste(Merged, strrep(paste(colnames(Content[i]), ''), Content[, i]))
}
Merged


immmerge <- rbind(immmerge,as.matrix(Merged, sep=''))
}


TrumpImm.wurl <- read_html("https://en.wikipedia.org/wiki/Immigration_policy_of_Donald_Trump")
TrumpImm.pcurl <- read_html("https://www.thebalance.com/donald-trump-immigration-impact-on-economy-4151107")
TrumpImm.w <- (TrumpImm.wurl %>% html_nodes("p+ ul li , ul+ p , .navigation-not-searchable+ p , h4+ p , .tleft+ p , .templatequote+ p , .templatequote p , .navigation-not-searchable , .tright+ p , #mw-content-text h3 , h3+ p , h2+ p , p+ p , .hlist+ p , p .mw-redirect") %>% 
                 html_text())
TrumpImm.pc <- (TrumpImm.pcurl %>% html_nodes("#mntl-sc-block_1-0-26 li , p") %>% 
                  html_text())
TrumpImm.w = paste(TrumpImm.w, TrumpImm.pc)
TrumpImm.con <- TrumpImm.w 

immmerge <- rbind(immmerge,as.matrix(TrumpImm.w, sep=''))




{
immerge.con = immmerge
immerge.clean <- as.matrix(immerge.con)
immerge.clean <- as.character(immerge.clean)
immerge.cleandf <- data_frame(immerge.clean)
colnames(immerge.cleandf)<- ("text")
immerge.cleandf$text=  gsub("true", "", immerge.cleandf$text)
immerge.cleandf$text=  gsub("trump", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("&amp", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("@\\w+", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("[[:punct:]]", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("[[:digit:]]", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("http\\w+", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("[ \t]{2,}", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("^\\s+|\\s+$", "", immerge.cleandf$text)
immerge.cleandf$text = gsub("function", "", immerge.cleandf$text)
immerge.cleandf$text <- iconv(immerge.cleandf$text, "UTF-8", "ASCII", sub="")
}
immerge.token <-immerge.cleandf %>% unnest_tokens(word, text)
immerge.token %>%
  count(word, sort = TRUE)





immerge.cleandf$text <- tolower(immerge.cleandf$text)
immerge.cleandf$text <- gsub("[^0-9A-Za-z///' ]", "", immerge.cleandf$text)

# create corpus
immerge.cleandfcorpus = Corpus(VectorSource(immerge.cleandf$text))


# remove punctuation, convert every word in lower case and remove stop words
cleancorpus <-{
  cnn.space <-content_transformer(function(x , pattern ) gsub(pattern, " ", x))
  immerge.cleandfcorpus <- tm_map(immerge.cleandfcorpus, removePunctuation )
  immerge.cleandfcorpus <- tm_map(immerge.cleandfcorpus, removeWords, stopwords("english") )
  immerge.cleandfcorpus <- tm_map(immerge.cleandfcorpus, stripWhitespace )
  immerge.cleandfcorpus <- tm_map(immerge.cleandfcorpus, removeNumbers )
  immerge.cleandfcorpus <- tm_map (immerge.cleandfcorpus, stemDocument)
  immerge.cleandfcorpus <- tm_map(immerge.cleandfcorpus, removeWords, c("function", "name","valu","return","npr","function","data","size","push","window",
                                                                        "var","wpmetadata","document","list","default","null","openx","dynam","amp","twp","pbexternalresourcesload pbexternalresourcesload",
                                                                        "clavisauxnam clavisauxnam","clavisaux","prop","articl","start","washingtonpost","customopt",
                                                                        "www","div","css","type","span","html","item","content","xpx","theme","url",
                                                                        "xtypenam","com","width","sprinkledbodi sprinkledbodi","font","tag","text","site",
                                                                        "link","jpg","import","xff","load","xbf","titl","link","http","um","fff","fals",
                                                                        "qxjawnsztpuexqlyhcnrpyxllzriyzaynzyltmnwetnwnjzsyqlwuyzdgyyjmngjmmw","nav","typenam",
                                                                        "filterempti filterempti","tri","true","generat","color","margin","webkit","index","mbr","utc")) 
}

# create document term matrix

tdm = TermDocumentMatrix(immerge.cleandfcorpus)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
wordcloud(immerge.cleandfcorpus, scale=c(5,.5),  min.freq = 1, max.words=500, random.order=FALSE, 
          rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))

emotions <- immerge.token %>% right_join(get_sentiments("nrc"))%>%
  filter(!is.na(sentiment)) %>%
  count(sentiment, sort = TRUE)

bing_word_counts <- immerge.token %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
ggplot(emotions,aes(x=emotions$sentiment, y=emotions$n, fill=emotions$sentiment)) + geom_bar(stat = "identity")
