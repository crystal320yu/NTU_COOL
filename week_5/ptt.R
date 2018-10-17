install.packages("rJava")
install.packages("Rwordseg", repos="http://R-Forge.R-project.org")
install.packages("tm")
install.packages("tmcn", repos="http://R-Forge.R-project.org", type="source")
install.packages("wordcloud")
install.packages("XML")
install.packages("RCurl")

post_url = function(url){
  #爬網清單(產生每篇文章的URL)
  url_list = list()
  ##擷取文章代碼 ex:M.1450857571.A.C8A
  url.list = xpathSApply(html, "//div[@class='title']/a[@href]", xmlAttrs)
  ##寫入文章url清單
  url_list = rbind(url_list, as.matrix(paste('www.ptt.cc', url.list, sep='')))
  return(url_list)
}
url_list = unlist(post_url(url))

#http://chienhung0304.blogspot.com/2015/12/r-ptt_24.html