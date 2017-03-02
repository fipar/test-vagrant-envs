#!/bin/bash
rpm -qa|grep mysql-community-release && exit 0 || {
	yum -y install http://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
	yum -y install mysql-community-server
        #yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	#yum -y install percona-xtrabackup percona-toolkit
	service mysqld start
}
