#!/bin/bash
rpm -qa|grep percona-release && exit 0 || {
	yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	yum -y install Percona-Server-server-51 Percona-Server-shared-51 Percona-Server-devel-51 Percona-Server-test-51 Percona-Server-client-51
	yum -y install percona-xtrabackup
	service mysql start
}
