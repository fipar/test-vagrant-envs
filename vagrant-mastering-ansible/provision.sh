#!/bin/bash
hostname | grep control > /dev/null && {
    dpkg -L ansible &> /dev/null || {
	    apt-get -y install software-properties-common
	    apt-add-repository ppa:ansible/ansible
	    apt-get update
	    apt-get -y install ansible
		}
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

verification_host=lb01
[ "$HOSTNAME" == "lb01" ] && verification_host=control
grep $verification_host /etc/hosts >/dev/null || {
	for name in control lb01 app01 app02 db01; do
		echo "${IP_BLOCK}.${machine_id} $name" >> /etc/hosts
		machine_id=$((machine_id+1))
	done
} || exit 0

