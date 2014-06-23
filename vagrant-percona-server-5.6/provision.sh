#!/bin/bash
rpm -qa|grep percona-release && exit 0 || {
	yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	yum -y install Percona-Server-server-56 Percona-Server-shared-56 Percona-Server-devel-56 Percona-Server-test-56 Percona-Server-client-56
	yum -y install percona-xtrabackup percona-toolkit
	service mysql start
}
