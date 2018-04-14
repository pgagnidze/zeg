### Introduction
Zabbix setup on Google Cloud with Puppet configuration management and startup scripts

### Steps
1. Install gems for GCP modules
   ```bash
    $ puppet resource package googleauth ensure=present provider=puppet_gem
    $ puppet resource package google-api-client ensure=present provider=puppet_gem
   ```
[source]: https://github.com/yoyowallet/devops-interview
