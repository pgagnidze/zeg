from lxml import html
from lxml import cssselect
import os
import requests
import json

page = requests.get('http://markets.wsj.com/us')
tree = html.fromstring(page.content)
prices = tree.xpath('//div[@id="majorStockIndexes_moduleId"]/table/tbody/tr')
cwd = os.getcwd()

data = []
for price in prices:
    cells = price.cssselect('td')
    data.append({
        'name': cells[0].findtext('a'),
        'last': price[1].text
    })

with open(cwd + '/data.json', 'w') as outfile:
    json.dump(data, outfile)
