#!/bin/bash

#yum update -y

test -d /data/db || {
    mkdir -p /data/db
    chown -R vagrant.vagrant /data/db
}

rpm -qa|grep -i tokumx || {
    rpm -ivh /home/vagrant/mongodb/tokumx/*rpm
}


