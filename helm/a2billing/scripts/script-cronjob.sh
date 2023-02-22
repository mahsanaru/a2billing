cd /tmp/
git clone https://github.com/mahsanaru/a2billing.git &&  rm -rf /tmp/a2billing/.git
cd /tmp/a2billing/
composer install
cp /tmp/a2billing/* /usr/local/src/a2billing/ 
wget https://raw.githubusercontent.com/mahsanaru/a2billing/develop/a2billing.conf -O /etc/a2billing.conf
sed -e '10,13d' < /etc/a2billing.conf > /etc/a2billing.conf.bak
awk 'NR==10{print "port = 3306\nuser = a2billinguser\npassword = a2billing\ndbname = mya2billing\n"}1' /etc/a2billing.conf.bak > /etc/a2billing.conf

