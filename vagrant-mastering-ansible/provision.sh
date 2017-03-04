#!/bin/bash

hostname | grep control > /dev/null && {
    rpm -qi epel-release > /dev/null || rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    rpm -qi ansible > /dev/null || yum -y install ansible
    test -f /home/vagrant/.ssh/mastering_ansible.pub || {
	    cp /vagrant/mastering* /home/vagrant/.ssh/
	    chown -R vagrant /home/vagrant/.ssh
	    chmod -R 600 /home/vagrant/.ssh/mastering*
    }
} || {
	cat /vagrant/mastering*pub >> /home/vagrant/.ssh/authorized_keys
}

IP_BLOCK=$(grep IP_BLOCK /vagrant/Vagrantfile |awk -F'=' '{print $2}'|tr -d '"'|head -1)
machine_id=2

[ $(wc -l /etc/hosts | awk '{print $1}') -le 3 ] && {
	for name in control lb01 app01 app02 db01; do
		echo "${IP_BLOCK}.${machine_id} $name" >> /etc/hosts
		machine_id=$((machine_id+1))
	done
} || exit 0

