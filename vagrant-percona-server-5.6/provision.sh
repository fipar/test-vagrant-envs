#!/bin/bash
rpm -qa|grep percona-release && exit 0 || {
	yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm 
	yum -y install Percona-Server-server-56 Percona-Server-shared-56 Percona-Server-devel-56 Percona-Server-test-56 Percona-Server-client-56
	yum -y install percona-xtrabackup percona-toolkit
	service mysql start
}
