library(ggplot2)
library(maps)
ggmap(map)

#設定bbox,輸入臺灣經緯度
taiwan<- c(left=119, bottom=21, right=123, top=26)
get_stamenmap(taiwan, zoom=7, maptype = "terrain") %>% ggmap()

#讀入csv，將各地經緯度列出
uv <- read.csv("UV_20151116152215.csv", encoding="big-5")
uv$lon <- uv$WGS84Lon
uv$lat <- uv$WGS84Lat

#依照uv做散布圖
map <- get_stamenmap(taiwan, zoom=7, maptype = "terrain")
ggmap(map) + 
  geom_point(aes(x = lon, y = lat, size = uv), data = uv) +
  scale_size(range = c(0, 3))
