library(rvest)
movie<- read_html("https://www.imdb.com/title/tt6911608/")


movie %>% html_node("div h1") %>% html_text()


movie %>% html_node(".summary_text") %>% html_text()


movie %>% html_node("strong span") %>% html_text()


