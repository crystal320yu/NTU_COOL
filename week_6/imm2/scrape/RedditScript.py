import praw
import json
reddit = praw.Reddit(client_id='aXHVKCmIe5uouw',
                     client_secret='A5liOJZHN1v2LM5qt71ytpbZOsQ',
                     user_agent='NewsCrawler')

titles = []
urls = []

subreddits = ['news', 'politics', 'usNEWS', 'immigration']
for subreddit in subreddits:
    for submission in reddit.subreddit(subreddit).hot(limit=1000):
        titles.append(submission.title)
        urls.append(submission.url)

    with open(subreddit + ".json", 'w') as file:
        json.dump({"Titles": titles, "Urls" : urls}, file)

