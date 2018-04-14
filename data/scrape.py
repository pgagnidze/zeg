from lxml import html
from lxml import cssselect
import requests

page = requests.get('http://markets.wsj.com/us')
tree = html.fromstring(page.content)
prices = tree.xpath('//div[@id="majorStockIndexes_moduleId"]/table/tbody/tr')

data = []
for price in prices:
    cells = price.cssselect('td')
    data.append({
        'name': cells[0].findtext('a'),
        'last': price[1].text
    })

out_file = open('data.json', 'w')
out_file.write(str(data))
out_file.close()
