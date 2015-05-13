#!/bin/bash

which git  || sudo yum -y install git
test -d /home/vagrant/devstack || { 
    cat<<EOF >/tmp/script.$$
    sudo yum -y remove puppet puppetlabs-release
    git clone https://github.com/openstack-dev/devstack.git
    cd devstack
    cat<<EOCONF >local.conf
[[local|localrc]]
ADMIN_PASSWORD=secrete
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
EOCONF
    ./stack.sh
EOF

   chmod 777 /tmp/script.$$
   sudo su - vagrant -c /tmp/script.$$

}

echo "If you need a fresh setup, don't vagrant provision, vagrant destroy && vagrant up instead"
