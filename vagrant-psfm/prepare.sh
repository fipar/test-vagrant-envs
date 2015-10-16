#!/bin/bash

sudo yum -y install openldap-servers openldap-clients cyrus-sasl cyrus-sasl-devel syrus-sasl-lib syrus-sasl-plain

cat <<EOF>_saslauthd.conf

ldap_servers: ldap://127.0.0.1:9009
ldap_search_base: dc=example,dc=com
ldap_filter: (cn=%u)
ldap_bind_dn: cn=openldapper,dc=example,dc=com
ldap_password: secret

EOF

sudo mv _saslauthd.conf /etc/saslauthd.conf

cat <<EOF > vagrant.ldif

dn: uid=vagrant,ou=users,dc=tgs,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: vagrant
uid: vagrant
uidNumber: 16859
gidNumber: 100
homeDirectory: /home/vagrant
loginShell: /bin/bash
gecos: vagrant
userPassword: {crypt}x
shadowLastChange: 0
shadowMax: 0
shadowWarning: 0

EOF


#ldapadd -x -D "cn=openldapper,dc=example,dc=com" -w secret -f vagrant.ldif
