#!/bin/bash
# Auto Install DirectAdmin with one command
# Author: mbrother
# Date: 16-07-2018
# Version: 1.0

# Set variables
GREEN='\e[92m'
RED='\e[31m'
REMOVE='\e[0m'
CLIENT_ID_CHECK=`echo $1 | cut -d"=" -f1`
LICENSE_ID_CHECK=`echo $2 | cut -d"=" -f1`
HOST_CHECK=`echo $3 | cut -d"=" -f1`

CLIENT_ID=`echo $1 | cut -d"=" -f2`
LICENSE_ID=`echo $2 | cut -d"=" -f2`
HOST=`echo $3 | cut -d"=" -f2`

# Check input values
show_help(){
    echo -e " ${RED}ERROR!${REMOVE}"
    echo " Please use this command:"
    echo -e " ${GREEN}sh $0 client=xxxxx license=xxxxxx host=xxx.xxx.xxx${REMOVE}"
    echo ""
    echo -e " or if you want install DirectAdmin for ${GREEN}LAN IP${REMOVE}:"
    echo -e " ${GREEN}sh $0 client=xxxxx license=xxxxxx host=xxx.xxx.xxx lan_ip=xxx.xxx.xxx.xxx${REMOVE}"
    echo ""
    echo " or if you want to custom web server, php version...:"
    echo -e " ${GREEN}sh $0 client=xxxxx license=xxxxxx host=cxxx.xxx.xxx lan_ip=xxx.xxx.xxx.xxx web-server=xxx php-version=x.x php-mode=xxx php2-version=x.x php2-mode=xxx ftp=xxx${REMOVE}"
    echo ""
    echo " ---"
    echo " client       : Client ID of DirectAdmin license"
    echo " license      : License ID of DirectAdmin license"
    echo " host         : Full hostname (FQDN) of server"
    echo " lan_ip       : LAN IP which you want to use ${GREEN}(your.lan.ip.address/no)${REMOVE}"
    echo -e " web-server   : Web server will be install ${GREEN}(apache/nginx/nginx_apache/litespeed)${REMOVE}"
    echo -e " php-version  : Default PHP version will be install ${GREEN}(5.3/5.4/5.5/5.6/7.0/7.1/7.2)${REMOVE}"
    echo -e " php-mode     : Default PHP mode will be install ${GREEN}(php-fpm/fastcgi/suphp/lsphp/mod_php)${REMOVE}"
    echo -e " php2-version : Second PHP version will be install ${GREEN}(5.3/5.4/5.5/5.6/7.0/7.1/7.2)${REMOVE}"
    echo -e " php2-mode    : Second PHP mode will be install ${GREEN}(php-fpm/fastcgi/suphp/lsphp/mod_php)${REMOVE}"
    echo -e " ftp          : FTP server will be install ${GREEN}(proftpd/pureftpd/no)${REMOVE}"
    echo ""
}

echo -e "${GREEN} Checking input values...${REMOVE}"
sleep 2

if [[ "${CLIENT_ID_CHECK}" != "client" ]] || [[ "${LICENSE_ID_CHECK}" != "license" ]] || [[ "${HOST_CHECK}" != "host" ]] || [[ -z "${CLIENT_ID}" ]] || [[ -z "${LICENSE_ID}" ]] || [[ -z "${HOST}" ]]
then
    show_help
    exit 1
fi

if [ ! -z $4 ]
then
    LAN_IP=`echo $4 | cut -d"=" -f2`
    if [ "${LAN_IP}" != "no" ]
	then
        CARD_NAME=`ip route | grep ${LAN_IP} | awk '{print $3}'`
        if [ -z ${CARD_NAME} ]
        then
            show_help
            echo -e "${RED} ERROR! IP ${REMOVE}$LAN_IP ${RED}does not exist on your server!${REMOVE}"
            exit 1
        fi
        CARD_PUBLIC="${CARD_NAME}:0"
    fi
fi

if [ ! -z $5 ]
then
    WEB_SERVER_CHECK=`echo $5 | cut -d"=" -f1`
    if [[ "${WEB_SERVER_CHECK}" != "web-server" ]]
    then
        show_help
        echo -e "${RED} Unknown option $5${REMOVE}"
        exit 1
    fi
    WEB_SERVER=`echo $5 | cut -d"=" -f2`


    if [ ! -z $6 ]
    then
        PHP1_VERSION_CHECK=`echo $6 | cut -d"=" -f1`
        if [[ "${PHP1_VERSION_CHECK}" != "php-version" ]]
        then
            show_help
            echo -e "${RED} Unknown option $6${REMOVE}"
            exit 1
        fi
        PHP1_VERSION=`echo $6 | cut -d"=" -f2`
    fi

    if [ ! -z $7 ]
    then
        PHP1_MOD_CHECK=`echo $7 | cut -d"=" -f1`
        if [[ "${PHP1_MOD_CHECK}" != "php-mode" ]]
        then
            show_help
            echo -e "${RED} Unknown option $7${REMOVE}"
            exit 1
        fi
        PHP1_MOD=`echo $7 | cut -d"=" -f2`
    fi
    
        if [ ! -z $8 ]
    then
        PHP2_VERSION_CHECK=`echo $8 | cut -d"=" -f1`
        if [[ "${PHP2_VERSION_CHECK}" != "php2-version" ]]
        then
            show_help
            echo -e "${RED} Unknown option $8${REMOVE}"
            exit 1
        fi
        PHP2_VERSION=`echo $8 | cut -d"=" -f2`
    fi
	
    if [ ! -z $9 ]
    then
        PHP2_MOD_CHECK=`echo $9 | cut -d"=" -f1`
        if [[ "${PHP2_MOD_CHECK}" != "php2-mode" ]]
        then
            show_help
            echo -e "${RED} Unknown option $9${REMOVE}"
            exit 1
        fi
        PHP2_MOD=`echo $9 | cut -d"=" -f2`
    fi
	
    if [ ! -z $10 ]
    then
        FTP_CHECK=`echo ${10} | cut -d"=" -f1`
        if [[ "${FTP_CHECK}" != "ftp" ]]
        then
            show_help
            echo -e "${RED} Unknown option ${10}${REMOVE}"
            exit 1
        fi
        FTP=`echo ${10} | cut -d"=" -f2`
    fi
fi

echo -e "${GREEN} PASS! Start to install...${REMOVE}"

# Install requirement packages
echo -e "${GREEN} Installing requirement packages...${REMOVE}"
sleep 2
yum -y install wget perl
IP_PUBLIC=`wget -q -O - http://myip.directadmin.com`

# Config LAN IP
if [[ -z $4 ]] || [[ "${LAN_IP}" == "no" ]]
then
    CARD_PUBLIC=`ip route get 1 | awk '{print $5; exit}'`
else
    echo -e "${GREEN} Configing LAN IP...${REMOVE}"
    sleep 2
    echo 1 > /root/.lan

    cat > "/etc/sysconfig/network-scripts/ifcfg-${CARD_PUBLIC}" <<EOF
DEVICE=${CARD_PUBLIC}
BOOTPROTO=none
ONPARENT=yes
IPADDR=${IP_PUBLIC}
NETMASK=255.255.255.255
ONBOOT=yes
ARPCHECK=no
EOF

    ifup ifcfg-${CARD_PUBLIC}
fi

# Install DirectAdmin
echo -e "${GREEN} Installing DirectAdmin ...${REMOVE}"
sleep 2
wget -O $HOME/setup.sh http://www.directadmin.com/setup.sh
cd $HOME

if [ -z $5 ]
then
    sh setup.sh <<EOF
y
${CLIENT_ID}
${LICENSE_ID}
${HOST}
y
${CARD_PUBLIC}
y
y
y
y
EOF
elif [ -z $8 ]
then
    sh setup.sh <<EOF
y
${CLIENT_ID}
${LICENSE_ID}
${HOST}
y
${CARD_PUBLIC}
y
y
n
yes
${WEB_SERVER}
pureftpd
${PHP1_VERSION}
${PHP1_MOD}
no
yes
yes
no
yes
yes
yes
yes
yes
y
EOF
else
    sh setup.sh <<EOF
y
${CLIENT_ID}
${LICENSE_ID}
${HOST}
y
${CARD_PUBLIC}
y
y
n
yes
${WEB_SERVER}
${FTP}
${PHP1_VERSION}
${PHP1_MOD}
yes
${PHP2_VERSION}
${PHP2_MOD}
yes
yes
no
yes
yes
yes
yes
yes
y
EOF
fi

rm -f $HOME/setup.sh
rm -f $0

# Show information after install
ADMIN_PASS=`cat /usr/local/directadmin/scripts/setup.txt | grep adminpass | cut -d"=" -f2`


if [[ -z $4 ]] || [[ "${LAN_IP}" == "no" ]]
then
    echo " ####################"
    echo -e " # ${GREEN}Everything DONE!${REMOVE} #"
    echo " ####################"
    echo " Login informations:"
    echo " Link:     http://${IP_PUBLIC}:2222"
    echo " user:     admin"
    echo " password: ${ADMIN_PASS}"
else
    echo " ###########################"
    echo -e " # Everything ${RED}ALMOST${REMOVE} done! #"
    echo " ###########################"
    echo " Login informations:"
    echo " Link:     http://${IP_PUBLIC}:2222"
    echo " user:     admin"
    echo " password: ${ADMIN_PASS}"

    echo "lan_ip=${LAN_IP}" >> /usr/local/directadmin/conf/directadmin.conf

    echo ""
    echo " #######################################"
    echo -e " # ${RED}CAUTION: YOU MUST DO THE FOLLOWING:${REMOVE} #"
    echo " #######################################"
    echo " - Add the LAN IP to DA's IP manager. Don't assign it to any Users or Domains."
    echo " - View the details of the external IP: Admin Level -> IP Manager -> Click the public/external IP."
    echo " - Link the internal IP to the external IP: Select the LAN IP from the drop down."
    echo " - Only select Apache, do not select DNS"
    echo " - Restart directadmin"

    echo ""
    echo "For more informations:"
    echo "https://www.directadmin.com/features.php?id=1377"
fi
