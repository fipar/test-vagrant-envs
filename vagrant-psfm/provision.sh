#!/bin/bash

install_if_needed()
{
   [ $# -eq 0 ] && {
	echo "usage: install_if_needed <package-name> <package-url>">&2
	exit 1
   }
   p=$1
   url=$2
   [ -z "$url" ] && url=$p
   rpm -qa|grep $p >/dev/null && return 0 || yum -y install $url
}

install_if_needed percona-release https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-4.noarch.rpm 
install_if_needed Percona-Server-MongoDB

