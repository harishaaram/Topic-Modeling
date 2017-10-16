import urllib, os
from BeautifulSoup import *
import time
import pprint

url = 'https://www.federalreserve.gov/newsevents/pressreleases/monetary20160127a.htm'
dir_path = "/home/harish/Desktop/test/"

html = urllib.urlopen(url).read()
soup = BeautifulSoup(html)
# pprint.pprint(soup)
# tags = soup.findAll('a', href=True)
div_summary = soup.findAll('div', { "class" : "col-xs-12 col-sm-8 col-md-8" })
# tags = div_summary.find_all('p')
# print div_summary
#
# # paragraphs = soup.find_all('p')
# # for paragraph in paragraphs:
# #     print(paragraph.get_text(strip=True))
# # # initialization
# # saveas = []
# # already_exist = bool

import bleach
html = "<b>Bad</b> <strong>Ugly</strong> <script>Evil()</script>"
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
# # looping through links
# for link in tags:
#     filename = link.get('href')
#     # download_link = url + filename
#     print filename

    # if filename[len(filename) - 3:] == 'pdf':
    #     saveas = filename
    #     saveas_splited = saveas.split('/')
    #     write_to_folder(saveas_splited)