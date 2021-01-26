#!/bin/bash
# shellcheck disable=SC2086

export MYSQL_PARAMS="-h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASSWORD}"

check_mysql_is_available() {
	mysqladmin $MYSQL_PARAMS ping 
}

create_db() {
	local db_name="$1"
	mysql $MYSQL_PARAMS -BNe "use ${db_name}" \
	|| {
		echo "Creating db $db_name"
		mysql $MYSQL_PARAMS -BNe "CREATE DATABASE $db_name CHARACTER SET $MYSQL_CHARACTER COLLATE $MYSQL_COLLATE"
		return 0
	}
	echo "The db $db_name exists. Skipping"
}

create_user() {
	local db_name="$1"; local user_pass="$2"
	mysql $MYSQL_PARAMS -BNe "SELECT 1 FROM mysql.user WHERE user = '$db_name'" | grep -q 1 \
	|| {
		echo "Creating user $db_name"
		mysql $MYSQL_PARAMS -BNe "CREATE USER '$db_name'@'%' IDENTIFIED BY '$user_pass'"
		test "$db_name" != "netdata" && mysql $MYSQL_PARAMS -BNe "GRANT ALL ON ${db_name}.* TO '$db_name'@'%'"
		test "$db_name" == "netdata" && mysql $MYSQL_PARAMS -BNe "GRANT REPLICATION CLIENT ON *.* TO '$db_name'@'%'"
		return 0
	}
	echo "The user $db_name exists. Skipping"
}

create_dbs_and_users() {
	test -n "$MYSQL_NETDATA_USER_PASSWORD" && create_user "netdata" "$MYSQL_NETDATA_USER_PASSWORD"

	for db in ${MYSQL_DBS//,/ }; do
		create_db "${db%%:*}"
		create_user "${db%%:*}" "${db#*:}"
	done
}

until check_mysql_is_available; do
	sleep 1
	(( MYSQL_TIMEOUT-- ))
	test $MYSQL_TIMEOUT -eq 0 && { echo "ERROR. MySQL is unavailable $MYSQL_HOST:$MYSQL_PORT"; exit 1;}
done 2>/dev/null

create_dbs_and_users 2>&1 | grep -v 'insecure'
