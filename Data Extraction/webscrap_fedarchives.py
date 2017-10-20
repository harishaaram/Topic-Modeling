import urllib, os
from bs4 import BeautifulSoup

import bleach

def archive_links(url):
    print url

    html = urllib.urlopen(url).read()
    soup = BeautifulSoup(html,"lxml")
    pp = soup.findAll('a', href= True, text='Minutes')
    for i in pp:
        document_name = str(i['href']).split('/')[3].split('.')[0] #for eg, if the href is '/fomc/minutes/20000202.htm', then 20000202 is doc name
        url_link = "https://www.federalreserve.gov" + str(i['href'])
        print url_link
        minutesText(url_link, document_name)


def minutesText(url, fname):
    htmls = urllib.urlopen(url).read()
    soups = BeautifulSoup(htmls,"lxml")
    div_summary = soups.findAll('td', {"width": 600})
    clean = bleach.clean(div_summary, tags=[], strip=True)
    saveFiles(clean, fname)

def saveFiles(text, fname):
    os.getcwd()

    os.chdir('/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/')

    fileCreate= open(fname + '.txt', 'w')
    fileCreate.write(text)
    fileCreate.close()


def main():
    url = 'https://www.federalreserve.gov/monetarypolicy/fomchistorical'
    startyear = 2000
    while startyear < 2018:#looping through years of minutes data
        print(startyear)
        archive_links(url + str(startyear) + '.htm')
        # break
        startyear += 1



if __name__ == '__main__':
    main()