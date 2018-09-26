library(rvest)
library(xml2)
library(igraph)
library(ggplot2)



#設爬蟲頁面
tennis.source <- read_html("https://www.atpworldtour.com/en/rankings/singles")

#set the rank(Top100)
tennis.rank <- c(1:100)
NROW(tennis.rank)

#用SelectorGadget定位節點資訊並爬取球員名
tennis.player <- tennis.source %>% html_nodes(".player-cell a") %>% html_text()
NROW(tennis.player)  

#用SelectorGadget定位節點資訊並爬取最新動態積分
tennis.point <- tennis.source %>% html_nodes(".points-cell a") %>% html_text() 
NROW(tennis.point)  

#用SelectorGadget定位節點資訊並爬取比賽次數
tennis.tournplayed <- tennis.source %>% html_nodes(".tourn-cell a") %>% html_text()
NROW(tennis.tournplayed)

  
#建立Dataframe
df.tennis <- data.frame(tennis.rank,tennis.player,tennis.point,tennis.tournplayed)
df.tennis


#取出倒數五名，使用ggplot依照分數劃出長條圖
df.tennis.info <- df.tennis[-c(1:95),]
tennis.point <- df.tennis.info$tennis.point %>% as.numeric()

pic <- ggplot(df.tennis.info, aes(x=tennis.player, y=tennis.point))+geom_bar(stat = "identity")
pic
