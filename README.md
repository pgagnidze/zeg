### Introduction
Zabbix setup on Google Cloud with Puppet configuration management and startup scripts

### Steps
1. Clean puppet environment
   ```bash
    $ rm -rf /etc/puppetlabs/code/environments/production/*
   ```
2. Clone this repository
   ```bash
    $ git clone https://github.com/papungag/zeg.git ~/zeg
   ```
3. Copy cloned repository content to puppet environment
   ```bash
    $ cp $HOME/zeg/* /etc/puppetlabs/code/environments/production/
   ```
4. Install gems for GCP modules
   ```bash
    $ puppet resource package googleauth ensure=present provider=puppet_gem
    $ puppet resource package google-api-client ensure=present provider=puppet_gem
   ```
5. Install GCP puppet modules
   ```bash
    $ puppet module install google-gcompute --version 0.2.1
    $ puppet module install google-gstorage --version 0.2.1
   ```
6. Setup infrastructure by running puppet apply command
   ```bash
    $ puppet apply -v /etc/puppetlabs/code/environments/production/manifests/instances.pp
   ```

[source]: https://github.com/yoyowallet/devops-interview
