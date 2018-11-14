import urllib.request
import re
import json


TAG_RE = re.compile(r'<[^>]+>')
SYM_RE = re.compile(r'[^\w]')

def remove_tags(text):
    return SYM_RE.sub(' ', TAG_RE.sub('', text))

opener = urllib.request.FancyURLopener({})

subreddit = ['news', 'politics', 'usNEWS', 'immigration']
titles = {}
urls = {}
for sub in subreddit:
    with open(sub + ".json", 'r') as file:
        jsonObj = json.load(file)
        titles[sub] = jsonObj["Titles"]
        urls[sub] = jsonObj["Urls"]

keywords = {
    'news':'immigr', 
    'politics':'immigr', 
    'usNEWS':'immigr', 
    'immigration':'trump'}

count = 1
done = set()
for sub in subreddit:
    for title, url in zip(titles[sub], urls[sub]):
        if url in done or keywords[sub] not in title.lower() or "reddit.com/r/" in url:
            continue
        done.add(url)
        try:
            print("Getting Submission #" + str(count))
            print("Loading site: " + title)
            f = opener.open(url)
            content = f.read()
            words = remove_tags(str(content)).split(' ')
            wordCounter = {}
            for word in words:
                if word == "" or len(word) < 3:
                    continue
                wordCounter[word] = wordCounter.get(word, 0) + 1

            fileContent = { "Title": title, "Content": wordCounter}
            with open(str(count) + ".json", 'w') as file:
                json.dump(fileContent, file)
            count += 1
        except :
            print(title + "Failed to parse")
            pass