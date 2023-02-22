#!/bin/bash
cd /tmp
apt-get update && apt install -y asterisk git
wget https://www.cepstral.com/downloads/installers/linux64/Cepstral_Lawrence_x86-64-linux_6.2.3.873.tar.gz
tar -xzf /tmp/Cepstral_Lawrence_x86-64-linux_6.2.3.873.tar.gz
cd /tmp/Cepstral_Lawrence_x86-64-linux_6.2.3.873
./install.sh agree xyes  2> /dev/null
ln -s /opt/swift/bin/swift /usr/bin/swift
mkdir /usr/local/src/a2billing
git clone https://github.com/mahsanaru/a2billing.git /usr/local/src/a2billing/ && rm -rf /usr/local/src/a2billing/.git
cd /usr/local/src/a2billing/
composer install
cp /usr/local/src/a2billing/a2billing.conf /etc/
sed -e '9,13d' < /etc/a2billing.conf > /etc/a2billing.conf.bak
awk 'NR==9{print "hostname = DB_HOSTNAME\nport = 3306\nuser = a2billinguser\npassword = a2billing\ndbname = mya2billing\n"}1' /etc/a2billing.conf.bak > /etc/a2billing.conf
sed -i -e "s/DB_HOSTNAME/$DB_HOSTNAME/g" /etc/a2billing.conf
cp /etc/asterisk/manager.conf /etc/asterisk/manager.conf.bak
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/asterisk/manager.conf.bak > /etc/asterisk/manager.conf
awk 'NR==10{print "[myasterisk]\nsecret=mycode\nread=system,call,log,verbose,command,agent,user\nwrite=system,call,log,verbose,command,agent,user\n"}1' /etc/asterisk/manager.conf.bak > /etc/asterisk/manager.conf 
chmod 777 /etc/asterisk
touch /etc/asterisk/additional_a2billing_iax.conf
touch /etc/asterisk/additional_a2billing_sip.conf
echo \#include additional_a2billing_sip.conf >> /etc/asterisk/sip.conf
echo \#include additional_a2billing_iax.conf >> /etc/asterisk/iax.conf
chown -Rf www-data /etc/asterisk/additional_a2billing_iax.conf
chown -Rf www-data /etc/asterisk/additional_a2billing_sip.conf
cd /usr/local/src/a2billing/AGI
cp a2billing.php /usr/share/asterisk/agi-bin/
cp a2billing_monitoring.php /usr/share/asterisk/agi-bin/
cp -Rf ../common/lib /usr/share/asterisk/agi-bin/
chmod +x /usr/share/asterisk/agi-bin/a2billing.php
chmod +x /usr/share/asterisk/agi-bin/a2billing_monitoring.php
ls /usr/local/src/a2billing/addons/
/usr/local/src/a2billing/addons/sounds/install_a2b_sounds.sh
chown -R asterisk:asterisk /usr/share/asterisk/sounds/
wget https://raw.githubusercontent.com/mahsanaru/a2billing/develop/helm/a2billing/scripts/extensions.conf
cat extensions.conf >> /etc/asterisk/extensions.conf