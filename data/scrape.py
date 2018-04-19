from lxml import html
from lxml import cssselect
from os.path import expanduser
from shutil import copy2
import requests
import json

page = requests.get('http://markets.wsj.com/us')
tree = html.fromstring(page.content)
prices = tree.xpath('//div[@id="majorStockIndexes_moduleId"]/table/tbody/tr')
home = expanduser("~")

data = []
for price in prices:
    cells = price.cssselect('td')
    data.append({
        'name': cells[0].findtext('a'),
        'last': price[1].text
    })

name = []
last = []
for entry in data:
        name.append(entry['name'])
        last.append(float(entry['last']))


print(last)
with open(home + '/name.json', 'w') as outfile:
    json.dump(name, outfile)
copy2(home + '/name.json', '/name.json')

with open(home + '/last.json', 'w') as outfile:
    json.dump(last, outfile)
copy2(home + '/last.json', '/last.json')