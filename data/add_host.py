from pyzabbix import ZabbixAPI, ZabbixAPIException
import sys

# The hostname at which the Zabbix web interface is available
ZABBIX_SERVER = 'http://127.0.0.1'

zapi = ZabbixAPI(ZABBIX_SERVER)

# Login to the Zabbix API
zapi.login('Admin', 'zabbix')
print("Connected to Zabbix API Version %s" % zapi.api_version())

host_name = 'WSJ'
hosts = zapi.host.get(filter={"host": host_name}, selectInterfaces=["interfaceid"])
if not hosts:
    hostid = zapi.host.create({ 
        "host": host_name,
        "interfaces": [
            {
                "type":1,
                "main":1,
                "useip":0,
                "ip":"127.0.0.1",
                "dns":"zabbix-agent",
                "port":10050
            }
        ],
        "groups": [
            {
                "groupid": "1"
            }
        ]})["hostids"][0]
    print("Added host with hostname {}".format(host_name))
else:
    print("Host with {} name already exists".format(host_name))
