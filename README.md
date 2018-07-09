# Auto-install-DirectAdmin-on-LAN-IP
---
A tool auto install DirectAdmin with one command

HOW TO USE:
1. Create a bash file (example auto.sh) with content of file auto_install.bash
2. Run this command if you want to install DirectAdmin on public (external) IP:

sh auto.sh -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx

Run this command if you want to install DirectAdmin on private (internal) IP:

sh auto.sh -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx -lan_ip=xxx.xxx.xxx.xxx

-client : Client ID of DirectAdmin license - replace xxxxx with your Client ID.

-license: License ID of DirectAdmin license - replace xxxxxx with your License ID.

-host   : Full hostname (FQDN) of server - replace xxx.xxx.xxx with Full hostname(FQDN) of your server.

-lan_ip : LAN IP which you want to use - repalce xxx.xxx.xxx.xxx with your LAN IP which you want to use to install DirectAdmin on it.
