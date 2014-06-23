#!/bin/bash
rpm -qa|grep percona-release && exit 0 || {
	yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
	yum -y install Percona-Server-server-55 Percona-Server-shared-55 Percona-Server-devel-55 Percona-Server-test-55 Percona-Server-client-55
	service mysql start
}
