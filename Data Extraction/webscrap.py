import urllib, os
# from BeautifulSoup import *
from bs4 import BeautifulSoup

import bleach

def eachStatement(url):

    html = urllib.urlopen(url).read()
    soup = BeautifulSoup(html,"lxml")
    div_summary = soup.findAll('div', { "class" : "col-xs-12 col-sm-8 col-md-8" })
    clean = bleach.clean(div_summary, tags=[], strip=True)
    print clean


def collect_monthly_statementUrls(url_mainpage):
    htmls = urllib.urlopen(url_mainpage).read()
    soups = BeautifulSoup(htmls,"lxml")
    # saveas = []
    # already_exist = bool
    # tags = soups.findAll('a', href=True)
    # divs = soups.findAll('div',{ "class" : "col-xs-12 col-md-4 col-lg-2" })
    hrefstatement = soups.findAll('a', href=True, text='Statement')
    # print hrefstatement
    ls = list()
    for div in hrefstatement:
        # print div['href']
        url_link = "https://www.federalreserve.gov"+str(div['href'])
        eachStatement(url_link)
        ls.append(url_link)
        # if div.find('a').contents[0] == 'Statement':
        #     print div.find('a')
    print ls
    return ls

def main():
    url_lists = 'https://www.federalreserve.gov/newsevents/pressreleases/monetary20160127a.htm'
    url_mainpage = 'https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm'
    url_lists = collect_monthly_statementUrls(url_mainpage)
    eachStatement(url_lists)



if __name__ == '__main__':
    main()