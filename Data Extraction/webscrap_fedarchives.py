import urllib, os
# from BeautifulSoup import *
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
        eachhref_saveFiles(url_link, document_name)
    # div_summary = soup.findAll('div', { "class" : "col-xs-12 col-md-6" })
    # clean = bleach.clean(div_summary, tags=[], strip=True)
    # print clean


def eachhref_saveFiles(url, fname):
    htmls = urllib.urlopen(url).read()
    soups = BeautifulSoup(htmls,"lxml")
    div_summary = soups.findAll('td', {"width": 600})
    clean = bleach.clean(div_summary, tags=[], strip=True)
    print clean


# # Checking in the local folder for the filename
# def check_for_file(fname):
#     for root, dirs, files in os.walk(dir_path):
#         if fname in files:
#             return True
#     return False
#
#
# # saving with the word after the last two(because two pdf with same name can exist in different path) backward slash
# def write_to_folder(saveas_splited):
#     time.sleep(1)
#     if len(saveas_splited) > 1:
#         save_filename = saveas_splited[len(saveas_splited) - 2] + '_' + saveas_splited[len(saveas_splited) - 1]
#         already_exist = check_for_file(save_filename)
#         if already_exist == False:
#             urllib.urlretrieve(download_link, dir_path + save_filename)
#     else:
#         already_exist = check_for_file(saveas_splited[0])
#         if already_exist == False:
#             urllib.urlretrieve(download_link, dir_path + saveas_splited[0])
#     return True
#
#
# looping through links
# for link in tags:
#     filename = link.get('href')
#     # download_link = url + filename
#     print filename
#
#     if filename[len(filename) - 3:] == 'pdf':
#         saveas = filename
#         saveas_splited = saveas.split('/')
#         write_to_folder(saveas_splited)\

def main():
    # url_lists = 'https://www.federalreserve.gov/newsevents/pressreleases/monetary20160127a.htm'
    # url_mainpage = 'https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm'
    # url_lists = collect_monthly_statementUrls(url_mainpage)
    # eachStatement(url_lists)
    url = 'https://www.federalreserve.gov/monetarypolicy/fomc_historical_year.htm'
    url = 'https://www.federalreserve.gov/monetarypolicy/fomchistorical'
    startyear = 2000
    while startyear < 2018:#looping through years of minutes data
        print(startyear)
        archive_links(url + str(startyear) + '.htm')
        break
        startyear += 1



if __name__ == '__main__':
    main()