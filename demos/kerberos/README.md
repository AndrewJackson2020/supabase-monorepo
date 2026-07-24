# Kerberos Demo

## Usage

Build and run container
```bash
podman build . --tag=kerberos_demo
podman run 
```

```bash
podman exec -it ${CONTAINER_ID} /bin/bash
```

```bash
# Fails
/usr/lib/postgresql/18/bin/psql -U root -h $(cat /etc/hostname) -d postgres -p 5432

# Succeeds
echo 'root' | kinit root
/usr/lib/postgresql/18/bin/psql -U root -h $(cat /etc/hostname) -d postgres -p 5432

echo 'root' | kinit root
/usr/lib/postgresql/18/bin/psql -U root -h $(cat /etc/hostname) -d postgres -p 5432
```

## Future work
- Build simple http app to auth in kerberos
- Auto populate foreign server, foreign table, etc
- Attempt to use forwardable tickets to auth from psql -> postgres -> pg_net -> http app
