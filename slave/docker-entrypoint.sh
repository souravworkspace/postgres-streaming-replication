#!/bin/bash
if [ ! -s "$PGDATA/PG_VERSION" ]; then
echo "*:*:*:$PG_REPL_USER:$PG_REPL_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass
until nc -w 1 -vz ${PG_MASTER_HOST} ${PG_MASTER_PORT}
do
echo "Waiting for master to start..."
sleep 1s
done
until pg_basebackup -h ${PG_MASTER_HOST} -p ${$PG_MASTER_PORT} -D ${PGDATA} -U ${PG_REPL_USER} -vP --no-password
do
echo "Waiting for master to connect..."
sleep 1s
done
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
cat > ${PGDATA}/recovery.conf <<EOF
standby_mode = on
primary_conninfo = 'host=$PG_MASTER_HOST port=$PG_MASTER_PORT user=$PG_REPL_USER password=$PG_REPL_PASSWORD'
EOF
chown postgres. ${PGDATA} -R
chmod 700 ${PGDATA} -R
fi
sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf
exec "$@"
