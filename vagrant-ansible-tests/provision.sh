#!/bin/bash
hostname | grep control > /dev/null && {
    dpkg -L ansible &> /dev/null || {
	    apt-get -y install software-properties-common
	    apt-add-repository ppa:ansible/ansible
	    apt-get update
	    apt-get -y install ansible
		}
    test -f /home/vagrant/.ssh/ansible_tests.pub || {
	    cp /vagrant/ansible* /home/vagrant/.ssh/
	    chown -R vagrant /home/vagrant/.ssh
	    chmod -R 600 /home/vagrant/.ssh/ansible*
    }
} || {
	cat /vagrant/ansible*pub >> /home/vagrant/.ssh/authorized_keys
}

IP_BLOCK=$(grep IP_BLOCK /vagrant/Vagrantfile |awk -F'=' '{print $2}'|tr -d '"'|head -1)
machine_id=2

verification_host=lb01
[ "$HOSTNAME" == "lb01" ] && verification_host=control
grep $verification_host /etc/hosts >/dev/null || {
	for name in control $(for i in $(seq 2); do echo -n "app0$i "; done) $(for i in $(seq 3); do echo -n "db0$i "; done); do
		echo "${IP_BLOCK}.${machine_id} $name" >> /etc/hosts
		machine_id=$((machine_id+1))
	done
} || exit 0

