library(httr)

url <- "https://ecshweb.pchome.com.tw/search/v3.3/all/results?q=airpods&page=1&sort=rnk/dc"
res = GET(url)
res_json = content(res)
raw = (data.frame(do.call(rbind,res_json$prods)))

