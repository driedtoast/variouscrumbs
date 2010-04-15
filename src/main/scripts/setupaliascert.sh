#!/bin/sh

#############################################
## Changes a puppet cert to an alias hostname 
## and changes back the host
## moves key to master.pem
## master.pem is referred in the http conf 
## for puppet
#############################################

ORIG_HOSTNAME=`hostname`
echo "Original hostname: $ORIG_HOSTNAME"

NEW_HOSTNAME="puppetmaster.mydomain.com"
hostname $NEW_HOSTNAME
echo `hostname`
/sbin/service httpd stop
/sbin/service puppetmaster start
/sbin/service puppetmaster stop
hostname $ORIG_HOSTNAME
cp /var/lib/puppet/ssl/certs/*puppet*.com.pem /var/lib/puppet/ssl/certs/master.pem
cp /var/lib/puppet/ssl/private_keys/*puppet*.com.pem /var/lib/puppet/ssl/private_keys/master.pem
/sbin/service httpd start

