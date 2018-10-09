#install.packages("leaflet")
library(ggplot2)
library(maps)
library(ggmap)
library(leaflet)


#設定bbox,輸入臺灣經緯度
taiwan<- c(left=119, bottom=21, right=123, top=26)
get_stamenmap(taiwan, zoom=7, maptype = "terrain") %>% ggmap()


#讀入csv，將各地經緯度列出
uv <- read.csv("UV_20151116152215.csv", encoding="utf-8")
lon <- uv$WGS84Lon
lat <- uv$WGS84Lat
site <- as.character(uv$sitename)
County <- as.character(uv$County)
uvdata <- uv$uv

#依照uv做散布圖
map <- get_stamenmap(taiwan, zoom=7, maptype = "terrain")
firstmap = ggmap(map) + 
           geom_point(aes(x = lon, y = lat, size = uv), data = uv) +
           scale_size(range = c(0, 3))

pop <- leaflet(data= uv) %>% 
  addTiles() %>% 
  addMarkers(lon, lat, popup=paste("地點：", site, "<br>", "紫外線指數:", uvdata)) %>%
  addProviderTiles(providers$OpenStreetMap)


pop



saveWidget(m, file="map.html")
