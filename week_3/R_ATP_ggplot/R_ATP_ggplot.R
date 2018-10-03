
##1.
#列出ATP排名前3在不同比賽場地材質(Clay&Grass)獲勝機率

zip.file <- "TennisData_ATP.zip"

#Download file
if (!file.exists(zip.file)){
  download.file('https://github.com/JeffSackmann/tennis_atp/archive/master.zip', destfile = zip.file)
  
}

# unzip it
dir.out <- 'tennis_atp-master/'
if (!dir.exists(dir.out)) unzip(zip.file)

#列出目錄/文件夾的檔案 file:///C:/Users/user/Desktop/dir.pdf
Tennis.file <- list.files(dir.out, pattern = '*.csv', full.names = T)
print(Tennis.file)

#從上一個結果可以看出zip裡面不只有match還有rankings
#但是我只有要用有match的文件，所以用stringr來處理
library(stringr)
Tennis.mfile <- Tennis.file[str_detect(Tennis.file, "match")]
Tennis.mfile

#讀取資料，設定cols
library(readr)
library(dplyr)

Tennis.col <- cols(
  .default = col_integer(),
  tourney_id = col_character(),
  tourney_name = col_character(),
  surface = col_character(),
  tourney_level = col_character(),
  winner_name = col_character(),
  winner_ioc = col_character(),
  winner_age = col_integer(),
  loser_name = col_character(),
  loser_ioc = col_character(),
  loser_age = col_integer(),
  score = col_character(),
  round = col_character()
)

#運用do.call & lapply處理資料
df.tennisMatches <- do.call(bind_rows, lapply(Tennis.mfile, read_csv, col_types = Tennis.col)) 
df.tennisMatches$Date <- as.Date(as.character(df.tennisMatches$tourney_date), '%Y%m%d')
df.tennisMatches$Years <- format(df.tennisMatches$Date, format= "%Y")
str(df.tennisMatches)

#搜尋網路上ATP排名前100名的選手
library(xml2)
library(rvest)
res <- read_html("https://www.atpworldtour.com/en/rankings/singles") 
top100.players <- res %>% html_nodes(".player-cell a") %>% html_text() 

#只求前3名的選手名
top3.name <- top100.players[1:3]

#從data frame中找出跟網站上名字最相近的字
#由於web上目前排名14的阿根挺籍選手Diego Schwartzman，在CSV中顯示為Diego Sebastian Schwartzman。
#藉由amatch找出相近字串這個方法會一直跑出另一個Diego Sxxxxxx的選手。
#因此我用手動調整csv檔，將所有的Diego Sebastian Schwartzman replace by Diego Schwartzman。
library(stringdist)
player.name <- unique(c(df.tennisMatches$winner_name, df.tennisMatches$loser_name))
similar.name <- amatch(top3.name,player.name, maxDist = 3 )
data.frame(name.from.web = top3.name, name.from.csv = player.name[similar.name])

top3.name <- player.name[similar.name]
#運用tibble可以更方便使用dplyr
#讀取前3名
Tennis.table <- tibble()
for( my.player in top3.name){
  perc <- filter(df.tennisMatches, (winner_name==my.player)|(loser_name==my.player))
  perc$Name <- my.player
  perc.tab <- perc %>% group_by(Name, Years, surface) %>% summarise("Percentage of win" = sum(winner_name== Name)/n(),
                                 "Number of matches" = n()) %>% 
    filter("Number of matches" > 0) %>%
    filter(surface %in% c("Grass","Clay"))
  Tennis.table <- bind_rows(Tennis.table,perc.tab)
}

#加入ranking
Tennis.table$Name <- paste0(Tennis.table$Name,
                          '(',
                          match(Tennis.table$Name, top3.name),
                          ')')
Tennis.table <- Tennis.table[complete.cases(Tennis.table),]
Tennis.table


library(ggplot2)

p <- ggplot(Tennis.table, aes(x = as.numeric(Years), y = `Percentage of win`, color=surface))
p <- p + geom_point() + geom_smooth()
p <- p + facet_grid(surface~Name)
p <- p + ylim(c(0.25,1)) + xlim(c(2005,2016))
print(p)

#結論由圖可了解，對Djokovic& Nadal來說，clay(硬地)材質的環境比較容易獲勝；Federer在草地上發揮得比較平均。

##2.列出Novak Djokovic在不同比賽場地材質獲勝機率
#由於我最喜歡的選手為"Novak Djokovic"，因此決定再對他個人進行分析
#使用subset，先選出2018中比賽贏&輸時的比賽場地材質(surface)

my.favplayer.w <- subset(df.tennisMatches, winner_name=="Novak Djokovic", select = c(surface))
my.favplayer.l <- subset(df.tennisMatches,loser_name=="Novak Djokovic", select = c(surface))

#將輸及贏的場地用rbind結合，算出不同場地材質的比賽總次數
total.df <- rbind(my.favplayer.w, my.favplayer.l)

#依照不同場地材質(贏次數/總次數)
perc.df <- as.data.frame(table(my.favplayer.w) / table(total.df) )
colnames(perc.df) <- c("surface","percentage")

#plot
#做圖，將顏色改為橘色填滿，外框用黑色，調整柱狀圖寬度
#列出Novak Djokovic在不同比賽場地材質獲勝機率
library(ggrepel)
p.per <- ggplot(perc.df, aes(surface, percentage))+geom_bar(stat='identity',colour="black",  fill= "orange",width = 0.8)+ 
  theme_bw()
print(p.per)
#結論由圖可了解，對Djokovic& Nadal來說，Hard(硬地)材質的環境比較容易獲勝


##3.每個國家在2018年共出賽多少選手，並選出人數>8名，做出圖表

#library
library(xml2)
library(rvest)
library(stringr)
library(readr)
library(dplyr)

#讀取csv檔
Tennis2018.source <-read.csv("file:///C:/Users/user/Desktop/NTU_COOL/week_3/tennis_atp-master/atp_matches_2018.csv")

#運用sebset選出winner_name, loser_name, winner_ioc, loser_ioc
#將col名字改為一樣，用rbind連接，並使用unique
subset.1 <- subset(Tennis2018.source, select = c(winner_name, winner_ioc))
subset.2 <- subset(Tennis2018.source, select = c(loser_name, loser_ioc))
colnames(subset.1) <- c("name", "country")
colnames(subset.2) <- c("name", "country")
subset.d <- rbind(subset.1, subset.2)
subset.d <- unique(subset.d)
s <- as.data.frame(table(subset.d$country))
colnames(s) <- c("country", "count")

#由小到大排序後，選出人數>8的國家
s <- s[order(s$count),]
s.select <- s[72:80,]


#做圖，運用geom_text列出選手數量
ioc.p <- ggplot(s.select ,aes(x = country, y = count)) +  geom_bar(stat='identity',colour="white",  fill= "blue")+coord_flip() + theme_bw()+
  geom_text(aes(x = country, y = 1, label = paste0("(",count,")",sep="")),
            hjust=0, vjust=.5, size = 4, 
            colour = 'white',fontface = 'bold')+
  labs(x = 'Country', y = 'Count', 
       title = 'Country and Count')
print(ioc.p)






