mkdir /usr/local/src/a2billing
git clone https://github.com/mahsanaru/a2billing.git /usr/local/src/a2billing/ && rm -rf /usr/local/src/a2billing/.git
cd /usr/local/src/a2billing/
composer install
mkdir /app/a2billing
mkdir -p /var/lib/a2billing/script
mkdir -p /var/run/a2billing
cp /usr/local/src/a2billing/composer.* /app/a2billing
cp -rf /usr/local/src/a2billing/agent /app/a2billing
cp -rf /usr/local/src/a2billing/customer /app/a2billing
cp -rf /usr/local/src/a2billing/common /app/a2billing
cp -rf /usr/local/src/a2billing/vendor /app/a2billing
cp /usr/local/src/a2billing/a2billing.conf /etc/
sed -e '9,13d' < /etc/a2billing.conf > /etc/a2billing.conf.bak
awk 'NR==9{print "hostname = DB_HOSTNAME\nport = 3306\nuser = a2billinguser\npassword = a2billing\ndbname = mya2billing\n"}1' /etc/a2billing.conf.bak > /etc/a2billing.conf
sed -i -e "s/DB_HOSTNAME/$DB_HOSTNAME/g" /etc/a2billing.conf
chmod 755 /usr/local/src/a2billing/admin/templates_c
chmod 755 /usr/local/src/a2billing/customer/templates_c
chmod 755 /usr/local/src/a2billing/agent/templates_c
chown -Rf www-data:www-data /usr/local/src/a2billing/customer/templates_c


chmod -R 755 /app/
chown -Rf www-data:www-data /app/
