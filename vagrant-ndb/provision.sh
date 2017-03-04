#!/bin/bash -x

which wget>/dev/null || sudo yum -y install wget

test -d /home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64/ || {
    wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.5/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64.tar.gz &>/dev/null
    tar xzvf mysql-cluster*tar.gz && rm -f mysql-cluster*tar
}

test -d /home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64/ && {
    grep mysql-cluster /etc/profile || echo 'export PATH=$PATH:/home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64' >>/etc/profile
}

    cat <<EOF>/etc/my.cnf
[mysqld]
# Options for mysqld process:
ndbcluster                      # run NDB storage engine
datadir=/var/lib/mysql

[mysql_cluster]
# Options for NDB Cluster  processes:
ndb-connectstring=192.168.1.50  # location of management server
EOF
    test -d /var/lib/mysql-cluster/ || mkdir /var/lib/mysql-cluster/
    cat <<EOF>/var/lib/mysql-cluster/config.ini
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2    # Number of replicas
DataMemory=80M    # How much memory to allocate for data storage
IndexMemory=18M   # How much memory to allocate for index storage
                  # For DataMemory and IndexMemory, we have used the
                  # default values. Since the "world" database takes up
                  # only about 500KB, this should be more than enough for
                  # this example Cluster setup.


[ndb_mgmd]
# Management process options:
hostname=192.168.1.50            # Hostname or IP address of MGM node
datadir=/var/lib/mysql-cluster  # Directory for MGM node log files

[ndbd]
# Options for data node "A":
                                # (one [ndbd] section per data node)
hostname=192.168.1.52           # Hostname or IP address
datadir=/usr/local/mysql/data   # Directory for this data node's data files

[ndbd]
# Options for data node "B":
hostname=192.168.1.53           # Hostname or IP address
datadir=/usr/local/mysql/data   # Directory for this data node's data files

[mysqld]
# SQL node options:
hostname=192.168.1.50           # Hostname or IP address
                                # (additional mysqld connections can be
                                # specified for this node for various
                                # purposes such as running ndb_restore)
[mysqld]
hostname=192.168.1.51
EOF

[ $(hostname|grep -c sql) -gt 0 ] && {
    # provisioning a management / sql node
    groupadd mysql
    useradd -g mysql -s /bin/false mysql
    ln -s /home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64/ /usr/local/mysql
    chmod +x /usr/local/mysql/bin/*
    test -d /var/lib/mysql || mkdir -p /var/lib/mysql/
    /usr/local/mysql/bin/mysqld --initialize-insecure
    chown -R mysql /var/lib/mysql/
    cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d
    chmod +x /etc/rc.d/init.d/mysql.server
    chkconfig --add mysql.server
    service mysql.server start 
    cat <<EOF >> /home/vagrant/.bashrc 
export PATH=$PATH:/usr/local/mysql/bin/
EOF
    cat <<EOF>/home/vagrant/.my.cnf 
[client]
user=root

EOF
    ifconfig -a | grep 192.168.1.50 >/dev/null && echo "starting mgmd" && /usr/local/mysql/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini --ndb_nodeid=0
}

[ $(hostname|grep -c data) -gt 0 ] && {
    # provisioning a data node
    cp /home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64/bin/ndbd /usr/local/bin  
    cp /home/vagrant/mysql-cluster-gpl-7.5.4-linux-glibc2.5-x86_64/bin/ndbmtd /usr/local/bin  
    chmod +x /usr/local/bin/ndb*
    mkdir -p /usr/local/mysql/data/
    /usr/local/bin/ndbmtd
}

echo "provision.sh complete"
exit 0
