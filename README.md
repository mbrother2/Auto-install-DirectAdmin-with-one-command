# Auto-install-DirectAdmin-with-one-command
---
A tool auto install DirectAdmin with one command

HOW TO USE:
1. Download bash script

curl -o auto_install.bash https://raw.githubusercontent.com/mbrother2/Auto-install-DirectAdmin-with-one-command/master/auto_install.bash

2. Run command 
+ If you want to install DirectAdmin on public (external) IP:

sh auto_install.bash -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx

+ If you want to install DirectAdmin on private (internal) IP:

sh auto_install.bash -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx -lan_ip=xxx.xxx.xxx.xxx

3. Explain

-client : Client ID of DirectAdmin license - replace xxxxx with your Client ID.

-license: License ID of DirectAdmin license - replace xxxxxx with your License ID.

-host   : Full hostname (FQDN) of server - replace xxx.xxx.xxx with Full hostname(FQDN) of your server.

-lan_ip : LAN IP which you want to use - repalce xxx.xxx.xxx.xxx with your LAN IP which you want to use to install DirectAdmin on it.
