import urllib, os
from bs4 import BeautifulSoup
import re

import bleach

def archive_links(url, startyear):
    print url

    html = urllib.urlopen(url).read()
    soup = BeautifulSoup(html,"lxml")
    pp = soup.findAll('a', href= True, text='Minutes')
    for i in pp:
        document_name = str(i['href']).split('/')[-1].split('.')[0] #for eg, if the href is '/fomc/minutes/20000202.htm', then 20000202 is doc name
        url_link = "https://www.federalreserve.gov" + str(i['href'])
        print url_link
        only_number_docname = re.sub("[^0-9]", "", document_name)#only numbers
        minutesText(url_link, only_number_docname,startyear)


def minutesText(url, fname, startyear):
    try:
        htmls = urllib.urlopen(url).read()
        soups = BeautifulSoup(htmls,"lxml")

        #the website is not designed in a standard format
        if startyear > 1995:
            div_summary = soups.findAll('td', {"width": 600})
        else:
            div_summary = soups.findAll('p', text=True)

        clean = bleach.clean(div_summary, tags=[], strip=True)
        saveFiles(clean, fname, startyear)
    except:
        pass

def saveFiles(text, fname, startyear):
    os.getcwd()

    os.chdir('/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/')
    directory = '/home/harish/PycharmProjects/Topic-Modeling/Data Extraction/dataset/'+str(startyear) + '/'
    if not os.path.exists(directory):
        os.makedirs(directory)

    os.chdir(directory)

    fileCreate= open(fname + '.txt', 'w')
    fileCreate.write(text)
    fileCreate.close()


def main():
    url = 'https://www.federalreserve.gov/monetarypolicy/fomchistorical'
    startyear = 1995
    while startyear <= 1996:#looping through years of minutes data
        print(startyear)
        archive_links(url + str(startyear) + '.htm', startyear)
        # break
        startyear += 1



if __name__ == '__main__':
    main()