#!/bin/sh
which mysql || sudo pkg install --yes percona56-client-5.6.35.80.0_1 percona56-server-5.6.35.80.0_1 percona-toolkit-2.2.17 
sudo ps -aux|grep mysql || sudo /usr/local/etc/rc.d/mysql-server onestart
