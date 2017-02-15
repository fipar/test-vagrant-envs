#!/bin/bash

test -f /etc/yum.repos.d/mongodb-org-3.4.repo || {
    cat <<EOF>/etc/yum.repos.d/mongodb-org-3.4.repo
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
EOF
}

rpm -qa|grep mongodb || {
    yum install -y mongodb-org
    systemctl start mongod 
}

echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag
