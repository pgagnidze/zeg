### Introduction
Zabbix setup on Google Cloud with Puppet configuration management and startup scripts

### Steps
1. Clone this repository and move content to the puppet environment directory (Backup existing puppet environment content)
   ```bash
    $ git clone https://github.com/papungag/zeg.git
    $ rm -rf /etc/puppetlabs/code/environments/production/*
    $ mv zeg/* /etc/puppetlabs/code/environments/production/
   ```
2. Install gems for GCP modules
   ```bash
    $ puppet resource package googleauth ensure=present provider=puppet_gem
    $ puppet resource package google-api-client ensure=present provider=puppet_gem
   ```
3. Install GCP puppet modules
   ```bash
    $ puppet module install google-gcompute --version 0.2.1
    $ puppet module install google-gstorage --version 0.2.1
   ```
4. Setup infrastructure by running puppet apply command (Please make sure that you have configured service accounts for google cloud authentication and gsutil for file upload to google storage)
   ```bash
    $ puppet apply -v /etc/puppetlabs/code/environments/production/manifests/instances.pp
   ```