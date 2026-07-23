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
/usr/lib/postgresql/18/bin/psql -U root -h 55563667512f -d postgres

# Succeeds
echo 'root' | kinit root
/usr/lib/postgresql/18/bin/psql -U root -h 55563667512f -d postgres
```

## Future work
- Build simple http app to auth in kerberos
- Attempt to use forwardable tickets to auth from psql -> postgres -> pg_net -> http app
