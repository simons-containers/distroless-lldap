FROM archlinux:base-devel-20260308.0.497099 AS builder

ARG LLDAP_VERSION
ARG LLDAP_TARBALL=amd64-lldap.tar.gz
ARG GITHUB_URL=https://github.com/lldap/lldap/releases/download

WORKDIR /tmp/lldap
RUN curl --silent --show-error --location --output lldap.tar.gz \
  "${GITHUB_URL}/v${LLDAP_VERSION}/${LLDAP_TARBALL}" \
  && tar xzf lldap.tar.gz --strip-components=1

FROM scratch
ARG LLDAP_VERSION

COPY --from=builder /tmp/lldap/app /usr/share/lldap/app
COPY --from=builder /tmp/lldap/lldap /usr/bin/
COPY --from=builder /tmp/lldap/lldap_migration_tool /usr/bin/
COPY --from=builder /tmp/lldap/lldap_set_password /usr/bin/

ENV LLDAP_KEY_FILE=/etc/lldap/server_key
ENV LLDAP_DATABASE_URL=sqlite:///etc/lldap/users.db?mode=rwc
ENV LLDAP_LDAPS_OPTIONS__KEY_FILE=/etc/lldap/key.pem
ENV LLDAP_LDAPS_OPTIONS__CERT_FILE=/etc/lldap/cert.pem

WORKDIR /usr/share/lldap

CMD ["/usr/bin/lldap", "run", "-v", "--config-file", "/etc/lldap/config.toml"]

LABEL org.opencontainers.image.title="distroless lldap"
LABEL org.opencontainers.image.description="distroless lldap"
LABEL org.opencontainers.image.version="${LLDAP_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/simons-containers/distroless-lldap"
LABEL org.opencontainers.image.volumes.config="/etc/lldap"
