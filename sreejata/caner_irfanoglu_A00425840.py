# Data Mining Sreejata Assignment 1
# Submitted by Caner Irfanoglu A00425840

import tweepy
import re
import random
from googlesearch import search
import json

def trend_googler(N_trends = 5, N_links = 3):

    '''
        trend_googler works in two folds. First, queries twitter trends, then searches them on google.
        While querying twitter it is ensured that the trends contain only valid characters.
        Google search is made for trending topics and major newspapers.
        Having the trending topic in result is mandatory in the search.
        User can pass 2 parameters to the function. Number of trends to fetch, and number of links to get.
        The results are written as a dictionary to file.
        If the twitter_news.txt is already in user's path, then new results are appended the file
    '''


######################################## AUTHORIZATION #########################################

    consumer_key = ""
    consumer_secret = ""
    access_token_key = ""
    access_token_secret = ""
    # Saving twitter api access variables


    auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token_key, access_token_secret)
    api = tweepy.API(auth)
    # Setting up twitter API connection

    #################################################################################################

    ######################################## PREPARING TWITTER TRENDS TO SEARCH #####################

    try:
        api_list = api.trends_place(1)
    except:
        print('Error Occured while querying twitter API for trends')

    # Querying twitter API for trends and getting a list
    api_dict = api_list[0]
    # There is only 1 dict item in list. It is saved to trends_dict

    trends_list = api_dict['trends']
    # Extracted 50 worldwide trends from api_dict

    valid_trends = [trend['name'].replace("#", "") for trend in trends_list if all
    (bool(re.match('[a-zA-Z]|[0-9]|\#|\\s',t)) for t in trend['name'])]
    # Only get trend names if they are consisted of, letters numbers whitespaces or # AND remove #

    if (len(valid_trends) >= N_trends):
        trends_to_search = random.sample(valid_trends, N_trends)
    elif (len(valid_trends) == 0):
        print("Could not find any valid trends")
    # Randomly selected n trends to search

    #################################################################################################

    ######################################## SEARCHING GOOGLE FOR NEWS ##############################

    newspaper_names = "(bbc OR cnn OR theguardian OR breitbard OR infowars OR The Sun OR " \
                      "The Independent OR The Times OR The Daily Telegraph OR USA Today OR " \
                      "The Observer Daily Mail OR The Wall Street Journal OR Newsday OR " \
                      "The Pioneer OR Daily Express OR The Sentinel)"
    # String for newspaper names to attach every google search

    result_dict = {}
    for trend in trends_to_search:
        search_term = "'{}' ".format(trend) + newspaper_names
        # Created search query string
        search_links = search(search_term, start=0, stop= N_links-1)
        # Get search result links
        link_list = []
        for l in search_links:
            link_list.append(l)
        result_dict[trend] = link_list
        # Append list of google links of search results to dict values, where trend is the key

    #################################################################################################

    ######################################## WRITE RESULTS TO FILE ##################################

    with open('twitter_news.txt', 'a') as file:
        file.write(json.dumps(result_dict, indent = 4, sort_keys = True))

#################################################################################################

if __name__ == '__main__':
    try:
        trend_googler()
        print('Program Ran Successfully. Results are written into twitter_news.txt')
    except:
        print('Error Occured When Calling trend_googler function')











