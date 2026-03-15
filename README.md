# Distroless lldap container

Bare-bones distroless ldap container image from `scratch`. The official releases for lldap are statically compiled and do not require any runtime. The scratch images is almost half the size of the official alpine container at 35M. 

## Running

Mount a persistent configuration volume at `/etc/lldap`. Minimun environment variables for a functioning container are `LLDAP_LDAP_USER_PASS` for default admin password and `LLDAP_JWT_SECRET` (recommended 32 chars).

Example:

```bash
docker run -it --rm \
  -v lldap-config:/etc/lldap \
  -e LLDAP_LDAP_USER_PASS=password \
  -e LLDAP_JWT_SECRET=$(openssl rand -hex 32) \
  -p 17170:17170 \
  ghcr.io/simons-containers/distroless-lldap:latest
```

The default container environment variables set are:
```
LLDAP_KEY_FILE=/etc/lldap/server_key
LLDAP_DATABASE_URL=sqlite:///etc/lldap/users.db?mode=rwc
LLDAP_LDAPS_OPTIONS__KEY_FILE=/etc/lldap/key.pem
LLDAP_LDAPS_OPTIONS__CERT_FILE=/etc/lldap/cert.pem
```

Example overriding database url with postgres:

```bash
docker run -it --rm \
  -v ./config:/etc/lldap \
  -e LLDAP_LDAP_USER_PASS=password \
  -e LLDAP_JWT_SECRET=$(openssl rand -hex 32) \
  -e LLDAP_DATABASE_URL=postgres://lldap:lldap@postgres:5432/lldap
  -p 17170:17170 \
  ghcr.io/simons-containers/distroless-lldap:latest
```

## Building

| Arg | Description |
|---|---|
| `LLDAP_VERSION` | Version of lldap to use

Build container:

```bash
docker build \
  -t distroless-lldap:${LLDAP_VERSION} \
  --build-arg LLDAP_VERSION=${LLDAP_VERSION} \
  -f Containerfile .
```

## License

Repository contents (e.g., `Containerfile`, build scripts, and configuration) are licensed under the **MIT License**.

Software included in built container images (such as **lldap**) are provided under their respective upstream licenses and are not covered by the MIT license for this repository.

## Acknowledgements

This project depends on a number of upstream components and data sources:

- **lldap** - Light LDAP implementation  
  https://github.com/lldap/lldap
