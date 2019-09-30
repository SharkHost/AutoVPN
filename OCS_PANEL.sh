#!/bin/bash

apt-get install boxes
sudo apt-get -y install ruby
sudo gem install lolcat

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

 red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'
			   
               echo "Connect ocspanel.info..."
               sleep 1
               
			   echo "���ѧ��Ǩ�ͺ Permision..."
               sleep 1
               
			   echo -e "${green}���Ѻ͹حҵ����...${NC}"
               sleep 1
			   
flag=0

if [ $USER != 'root' ]; then
	echo "�س��ͧ���¡��ҹ����� root"
	exit
fi

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;

if [[ -e /etc/debian_version ]]; then
	#OS=debian
	RCLOCAL='/etc/rc.local'
else
	echo "�س��������¡��ʤ�Ի������к���Ժѵԡ�� Debian"
	exit
fi

# GO TO ROOT
cd

MYIP=$(wget -qO- ipv4.icanhazip.com);


clear
echo "
----------------------------------------------
[?] �Թ�յ�͹�Ѻ������ : �к�ʤ�Ի 097-026-7262 
[1] Do you want to continue? [Y/n] = Y
[2] Do you want to continue? [Y/n] = Y
[?] 㹢�鹵͹���ͺ : Y... [ OK !! ]
----------------------------------------------
 " | lolcat
 sleep 3
sudo apt-get update
apt-get remove apt-listchanges
apt-get install curl
sudo apt install curl
sudo apt-get update
sudo apt-get install curl

clear
echo "
----------------------------------------------
[?] �Թ�յ�͹�Ѻ������ : �к�ʤ�Ի Ocspanel.info 
[?] Connect...
[?] Wellcome : ��سҷӵ����鹵͹... [ OK !! ]
----------------------------------------------
 " | lolcat
 sleep 5
clear 
echo "
----------------------------------------------
[?] OCS PANELS INSTALLER FOR DEBIAN 
[?] DEVELOPED BY OCSPANEL.INFO
[?] ( 097-026-7262 )
----------------------------------------------
 " | lolcat
clear
echo "
[?] ( ��س��׹�ѹ��õ�駤�ҵ�ҧ � �ѧ��� )
[?] ( �ҡ�س�����繴��¡Ѻ���ʼ�ҹ�ͧ��� ��§�� ź )
[?] ( 㹡�õԴ��駤����á�й���顴 Enter � 3���� )
---------------------------------------------- 
 "
echo "1.������ʼ�ҹ��������Ѻ user root MySQL:"
read -p "Password Root: " -e -i 123456789 DatabasePass
echo "----------------------------------------------" | lolcat
echo "2.��駤�Ҫ��Ͱҹ����������Ѻ OCS Panels"
echo "�ô�����Ѿ�û�����ҹ���������ѡ��о���������������մ��ҧ (_)"
read -p "Nama Database: " -e -i OCS_PANEL DatabaseName
echo "----------------------------------------------" | lolcat
echo "������ [ ���෾ ] ��Ҿ�������еԴ���ἧ OCS �ͧ�س����"
read -n1 -r -p "������ Enter ���ʹ��Թ��õ�� ..."

apt-get remove --purge mysql\*
dpkg -l | grep -i mysql
apt-get clean

apt-get install -y libmysqlclient-dev mysql-client

service nginx stop
service php5-fpm stop
service php5-cli stop

apt-get -y --purge remove nginx php5-fpm php5-cli

#apt-get update
apt-get update -y

apt-get install build-essential expect -y

apt-get install -y mysql-server

#mysql_secure_installation
so1=$(expect -c "
spawn mysql_secure_installation; sleep 3
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect \"\";  sleep 3; send \"Y\r\"
expect eof; ")
echo "$so1"
#\r
#Y
#pass
#pass
#Y
#Y
#Y
#Y

chown -R mysql:mysql /var/lib/mysql/
chmod -R 755 /var/lib/mysql/

apt-get install -y nginx php5 php5-fpm php5-cli php5-mysql php5-mcrypt


# Install Web Server
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/rasta-team/MyVPS/master/nginx.conf"
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/lnwseed/ocs-topup/master/vps.conf"
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

mkdir -p /home/vps/public_html

useradd -m vps

mkdir -p /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html

service php5-fpm restart
service nginx restart

apt-get -y install zip unzip

cd /home/vps/public_html

#wget http://xn--l3clxf6cwbe0gd7j.com/panelocs.zip
wget https://github.com/rasta-team/Full-OCS/raw/master/panelocs.zip

mv panelocs.zip LTEOCS.zip

unzip LTEOCS.zip

rm -f LTEOCS.zip

rm -f index.html

chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html

#mysql -u root -p
so2=$(expect -c "
spawn mysql -u root -p; sleep 3
expect \"\";  sleep 3; send \"$DatabasePass\r\"
expect \"\";  sleep 3; send \"CREATE DATABASE IF NOT EXISTS $DatabaseName;EXIT;\r\"
expect eof; ")
echo "$so2"
#pass
#CREATE DATABASE IF NOT EXISTS OCS_PANEL;EXIT;

chmod 777 /home/vps/public_html/application/controllers/topup/wallet/cookie.txt
chmod 777 /home/vps/public_html/application/config/database.php
chmod 755 /home/vps/public_html/application/controllers/topup/wallet/config.php
chmod 755 /home/vps/public_html/application/controllers/topup/wallet/manager/TrueWallet.php
chmod 755 /home/vps/public_html/application/controllers/topup/wallet/manager/Curl.php
chmod 755 /home/vps/public_html/truewallets/confirm.php
chmod 755 /home/vps/public_html/truewallets/get.php
chmod 755 /home/vps/public_html/truewallets/index.php
chmod 755 /home/vps/public_html/truewallets/input.php


clear
echo "
----------------------------------------------
[?] Server : �Ҷ֧��鹵͹�ش�������� 
[?] Connect...
[?] Wellcome : ��سҷӵ����鹵͹... [ OK !! ]
----------------------------------------------
[?] �Դ��������� http://$MYIP/install
[?] ��С�͡�����ŵ����ҹ��ҧ !
----------------------------------------------
 " | lolcat
echo ""
echo "Database:"
echo "- Database Host: localhost"
echo "- Database Name: $DatabaseName"
echo "- Database User: root"
echo "- Database Pass: $DatabasePass"
echo "----------------------------------------------"
echo "Admin Login:"
echo "- Username: ������[���෾]��ͧ���"
echo "- Password New: ������[���෾]��ͧ���"
echo "- Confirm Password New: ������[���෾]��ͧ���"
echo "
----------------------------------------------
[?] �Ӣ�����仵Դ��駷�� Browser ����������
[?] �ҡ��鹻Դ Browser ��С�Ѻ�ҷ���� (Putty)
[?] ���ǡ� [ENTER] !
----------------------------------------------
 " | lolcat
 
sleep 3
echo ""
read -p "�ҡ��鹵͹��ҧ����������ô������ [Enter] ���ʹ��Թ��õ�� ..."
echo ""
read -p "�ҡ [ ���෾ ] ������Ң�鹵͹��ҧ��������������ô������ [Enter] ���ʹ��Թ��õ�� ..."
echo ""

cd /root

apt-get update

service webmin restart

apt-get -y --force-yes -f install libxml-parser-perl

echo "unset HISTFILE" >> /etc/profile

sleep 2
cd /home/vps/public_html/
rm -rf install

sleep 3
clear
echo "
----------------------------------------------
[?] Source : m.me/ceolnw 
[?] ��鹵͹���仹������ҹ�ͺ..Y
[?] ���ѧ������Դ��� : Wallet..... [ OK !! ]
----------------------------------------------
 "
sudo apt-get install curl
sudo service apache2 restart
sudo apt-get install php5-curl
sudo service apache2 restart

sleep 4
# info
clear
echo "
----------------------------------------------
[?] ��س��������к� OCS Panel
[?] ��� http://$MYIP/
----------------------------------------------
[?] ���Ըա�õ�駤�Ұҹ������ / Wallet
[?] ��� Ocspanel.info/howto
----------------------------------------------
 " | lolcat
rm -f /root/ocsall.sh
cd ~/