# Auto-install-DirectAdmin-with-one-command
---
A tool auto install DirectAdmin with one command

HOW TO USE:
1. Download bash script

curl -o auto_install.bash https://raw.githubusercontent.com/mbrother2/Auto-install-DirectAdmin-with-one-command/master/auto_install.bash

2. Run command 
+ If you want to install DirectAdmin on public (external) IP:

sh auto_install.bash client=xxxxx license=xxxxxx host=xxx.xxx.xxx

+ If you want to install DirectAdmin on private (internal) IP:

sh auto_install.bash client=xxxxx license=xxxxxx host=xxx.xxx.xxx lan_ip=xxx.xxx.xxx.xxx

+ If you want to custom web server, php version...:

sh auto_install.bash client=xxxxx license=xxxxxx host=cxxx.xxx.xxx lan_ip=xxx.xxx.xxx.xxx web-server=xxx php-version=x.x php-mode=xxx php2-version=x.x php2-mode=xxx ftp=xxx

3. Explain

client       : Client ID of DirectAdmin license

license      : License ID of DirectAdmin license

host         : Full hostname (FQDN) of server

lan_ip       : LAN IP which you want to use (your.lan.ip.address/no)

web-server   : Web server will be install (apache/nginx/nginx_apache/litespeed)

php-version  : Default PHP version will be install (5.3/5.4/5.5/5.6/7.0/7.1/7.2)

php-mode     : Default PHP mode will be install (php-fpm/fastcgi/suphp/lsphp/mod_php)

php2-version : Second PHP version will be install (5.3/5.4/5.5/5.6/7.0/7.1/7.2)

php2-mode    : Second PHP mode will be install (php-fpm/fastcgi/suphp/lsphp/mod_php)

ftp          : FTP server will be install (proftpd/pureftpd/no)

4. Example

sh auto_install.bash client=12345 license=123456 host=local.mbr.dev

sh auto_install.bash client=12345 license=123456 host=local.mbr.dev lan_ip=192.168.1.8 

sh auto_install.bash client=12345 license=123456 host=local.mbr.dev lan_ip=192.168.1.8 web-server=nginx php-version=7.0 php-mode=php-fpm

sh auto_install.bash client=12345 license=123456 host=local.mbr.dev lan_ip=no web-server=nginx php-version=7.0 php-mode=php-fpm php-version=7.2 php-mode=php-fpm ftp=pureftpd
