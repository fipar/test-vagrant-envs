#!/bin/bash
rpm -qa|grep mysql-community-release && exit 0 || {
	yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
        yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	yum -y install http://dev.mysql.com/get/Downloads/MySQL-5.7/MySQL-test-5.7.4_m14-1.el6.i686.rpm http://dev.mysql.com/get/Downloads/MySQL-5.7/MySQL-devel-5.7.4_m14-1.el6.i686.rpm http://dev.mysql.com/get/Downloads/MySQL-5.7/MySQL-client-5.7.4_m14-1.el6.i686.rpm http://dev.mysql.com/get/Downloads/MySQL-5.7/MySQL-server-5.7.4_m14-1.el6.i686.rpm http://dev.mysql.com/get/Downloads/MySQL-5.7/MySQL-shared-5.7.4_m14-1.el6.i686.rpm
	yum -y install percona-xtrabackup percona-toolkit
	service mysql start
}
