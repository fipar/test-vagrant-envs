#!/bin/bash
rpm -qa|grep percona-release && exit 0 || {
	yum -y install http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
}
