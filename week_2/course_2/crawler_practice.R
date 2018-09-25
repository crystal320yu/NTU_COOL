### practice_3
### Crawler Example

### Crawler_Example with rvest    #####################################################################
#Use IMDb Top Box Office

rm(list = ls())
library(rvest)

# Set url
url <- "https://www.imdb.com/chart/boxoffice?ref_=nv_ch_cht"
# Get response
res <- read_html(url)

# Parse the content and extract the titles and ranks
raw.titles <- res %>% html_nodes(".titleColumn")
raw.weeksRank <- res %>% html_nodes(".weeksColumn")

# Extract link
movieName.link <- raw.titles %>% html_node("a") %>% html_attr('href')
weeksRank.link <- raw.weeksRank %>% html_node("a") %>% html_attr('href')

# Extract article
movieName.title <- raw.titles %>% html_text()
weeksRank.title <- raw.weeksRank %>% html_text()

# Create dataframe
topBoxMovie.df <- data.frame(movieName.title, weeksRank.title)

# Set df's colnames
topBoxMovie.df.col.names <- c("title", "rank")
colnames(topBoxMovie.df) <- topBoxMovie.df.col.names

topBoxMovie.df


