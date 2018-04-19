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

data = open('name.json').read()
json_dict = json.loads(data)

hosts = zapi.host.get(filter={"host": host_name}, selectInterfaces=["interfaceid"])
i = 0
if hosts:
    host_id = hosts[0]["hostid"]
    print("Found host id {0}".format(host_id))
    for entry in json_dict:
        i = i + 2
        try:
            item = zapi.item.create(
                hostid=host_id,
                name=entry,
                key_='system.run[grep \'"\' /data/last.json | cut -d \'"\' -f{}]'.format(i),
                type=0,
                value_type=4,
                interfaceid=hosts[0]["interfaces"][0]["interfaceid"],
                delay='5m'
            )
        except ZabbixAPIException as e:
            print(e)
            sys.exit()
        print("Added item with itemid {0} to host: {1}".format(item["itemids"][0], host_name))
else:
    print("No hosts found")