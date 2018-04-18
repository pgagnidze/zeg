from pyzabbix import ZabbixAPI, ZabbixAPIException
import sys
import json

# The hostname at which the Zabbix web interface is available
ZABBIX_SERVER = 'http://127.0.0.1'

zapi = ZabbixAPI(ZABBIX_SERVER)

# Login to the Zabbix API
zapi.login('Admin', 'zabbix')
print("Connected to Zabbix API Version %s" % zapi.api_version())

host_name = 'WSJ'

data = open('data.json').read()
json_dict = json.loads(data)

hosts = zapi.host.get(filter={"host": host_name}, selectInterfaces=["interfaceid"])

if hosts:
    host_id = hosts[0]["hostid"]
    print("Found host id {0}".format(host_id))
    for entry in json_dict:
        name_stock = entry['name']
        last_stock = entry['last']
        try:
            item = zapi.item.create(
                hostid=host_id,
                name=name_stock,
                key_=last_stock,
                type=0,
                value_type=3,
                interfaceid=hosts[0]["interfaces"][0]["interfaceid"],
                delay=30
            )
        except ZabbixAPIException as e:
            print(e)
            sys.exit()
        print("Added item with itemid {0} to host: {1}".format(item["itemids"][0], host_name))
else:
    print("No hosts found")