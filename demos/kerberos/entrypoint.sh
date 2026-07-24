#! /usr/bin/env bash

set -eoux pipefail

/root/setup_system_krb.sh

REALM='EXAMPLE.COM'
MASTER_PASSWORD='master_password'
KADMIN_PRINCIPAL='root'
KADMIN_PASSWORD='root'
KEYTAB_FILEPATH='/tmp/postgres.keytab'
KADMIN_PRINCIPAL_FULL="root@${REALM}"

krb5_newrealm <<EOF
    ${MASTER_PASSWORD}
    ${MASTER_PASSWORD}
EOF

HOSTNAME=$(cat /etc/hostname)

kadmin.local -q 'delete_principal -force postgres'
kadmin.local -q "delete_principal -force postgres/${HOSTNAME}"
kadmin.local -q "addprinc -pw ${KADMIN_PASSWORD} ${KADMIN_PRINCIPAL_FULL}"
kadmin.local -q "addprinc -randkey postgres"
sudo kadmin.local -q "addprinc -randkey postgres/${HOSTNAME}"
kadmin.local -q "ktadd -k /tmp/postgres.keytab postgres/${HOSTNAME}"
kadmin.local -q "ktadd -k /tmp/postgres.keytab postgres"
chmod 644 /tmp/postgres.keytab

# Create data directory and run postgres as postgres user
sudo -u postgres bash << 'EOF'
	# Start postgres instance 1
	DATA_DIR=$(mktemp -d)
	PG_BIN='/usr/lib/postgresql/18/bin'

	"${PG_BIN}/initdb" -D "${DATA_DIR}"

	echo 'host  	all  		all  		0.0.0.0/0  		gss  include_realm=0  krb_realm=EXAMPLE.COM' >> "${DATA_DIR}/pg_hba.conf"

	echo "
	krb_server_keyfile = 'FILE:/tmp/postgres.keytab'
	listen_addresses = '*'
	port = 5432
	gss_accept_delegation = on
	" >> "${DATA_DIR}/postgresql.conf"

	"${PG_BIN}/pg_ctl" -D "${DATA_DIR}" start -l "${DATA_DIR}/logfile"

	# Start postgres instance 2
	DATA_DIR=$(mktemp -d)
	PG_BIN='/usr/lib/postgresql/18/bin'

	"${PG_BIN}/initdb" -D "${DATA_DIR}"

	echo 'host  	all  		all  		0.0.0.0/0  		gss  include_realm=0  krb_realm=EXAMPLE.COM' >> "${DATA_DIR}/pg_hba.conf"

	echo "
	krb_server_keyfile = 'FILE:/tmp/postgres.keytab'
	listen_addresses = '*'
	port = 5433
	gss_accept_delegation = on
	" >> "${DATA_DIR}/postgresql.conf"

	"${PG_BIN}/pg_ctl" -D "${DATA_DIR}" start -l "${DATA_DIR}/logfile"

	tail -f /etc/hostname
EOF
