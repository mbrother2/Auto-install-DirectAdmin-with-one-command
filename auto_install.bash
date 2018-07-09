#!/bin/bash
# Auto Install DirectAdmin with one command
# Author: mbrother
# Date: 09-07-2018
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
    echo " sh $0 -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx"
    echo ""
    echo -e " or if you want install DirectAdmin for ${GREEN}LAN IP${REMOVE}:"
    echo " sh $0 -client=xxxxx -license=xxxxxx -host=xxx.xxx.xxx -lan_ip=xxx.xxx.xxx.xxx"
    echo " ---"
    echo " -client : Client ID of DirectAdmin license"
    echo " -license: License ID of DirectAdmin license"
    echo " -host   : Full hostname (FQDN) of server"
    echo " -lan_ip : LAN IP which you want to use"
}

echo -e "${GREEN} Checking input values...${REMOVE}"
sleep 2
if [[ "${CLIENT_ID_CHECK}" != "-client" ]] || [[ "${LICENSE_ID_CHECK}" != "-license" ]] || [[ "${HOST_CHECK}" != "-host" ]] || [[ -z "${CLIENT_ID}" ]] || [[ -z "${LICENSE_ID}" ]] || [[ -z "${HOST}" ]]
then
    show_help
    exit 1
elif [ ! -z $4 ]
then
    LAN_IP=`echo $4 | cut -d"=" -f2`
    CARD_NAME=`ip route | grep ${LAN_IP} | awk '{print $3}'`
    if [ -z ${CARD_NAME} ]
    then
        show_help
        echo -e "${RED} ERROR! IP ${REMOVE}$LAN_IP ${RED}does not exist on your server!${REMOVE}"
        exit 1
    fi
    CARD_PUBLIC="${CARD_NAME}:0"
    echo -e "${GREEN} PASS! Start to install...${REMOVE}"
fi

# Install requirement packages
echo -e "${GREEN} Installing requirement packages...${REMOVE}"
sleep 2
yum -y install wget perl
IP_PUBLIC=`wget -q -O - http://myip.directadmin.com`

# Config LAN IP
if [ -z $4 ]
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

# Install DirectAdmin with default option
echo -e "${GREEN} Installing DirectAdmin with default option...${REMOVE}"
sleep 2
wget -O $HOME/setup.sh http://www.directadmin.com/setup.sh
cd $HOME
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

rm -f $HOME/setup.sh
rm -f $0

# Show information after install
ADMIN_PASS=`cat /usr/local/directadmin/scripts/setup.txt | grep adminpass | cut -d"=" -f2`


if [ -z $4 ]
then
    echo " ####################"
    echo " -e # ${GREEN}Everything DONE!${REMOVE} #"
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
