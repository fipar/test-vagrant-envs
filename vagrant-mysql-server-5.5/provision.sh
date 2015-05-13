#!/bin/bash
rpm -qa|grep mysql-community-release && exit 0 || {
	yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
        yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	yum -y install mysql-server mysql-client mysql-shared
	yum -y install percona-xtrabackup percona-toolkit
	service mysql start
}
