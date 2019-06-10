#!/bin/bash
echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL
CREATE USER $PG_REPL_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REPL_PASSWORD';
EOSQL
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
wal_keep_segments = 32
hot_standby = on
EOF
