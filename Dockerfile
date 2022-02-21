FROM debian:buster-slim as build

ARG ELECTRS_BASE_URL=https://github.com/romanz/electrs.git
ARG ELECTRS_BRANCH=v0.9.4

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=$PATH:/root/.cargo/bin

RUN set -ex && \
  apt-get update && \
  apt-get install -qy \
    gpg \
    git \
    clang \
    cmake \
    curl && \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh && \
  sh /tmp/rustup.sh -y && \
  git clone --branch "${ELECTRS_BRANCH}" "${ELECTRS_BASE_URL}" && \
  cd electrs && \
  curl https://romanzey.de/pgp.txt | gpg --import && \
  git verify-tag ${ELECTRS_BRANCH}

RUN set +e && \
  cd /electrs && \
  cargo build --locked --release

FROM debian:buster-slim as electrs

# Image metadata
# git commit
LABEL org.opencontainers.image.revision="-"
LABEL org.opencontainers.image.source="https://github.com/jkaldon/arm64v8-electrs/tree/master"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -e && \
  apt-get update && \
  apt-get install -qy \
          bash \
          vim \
          coreutils && \
  useradd -d /home/electrs -m -s /usr/sbin/nologin electrs && \
  mkdir /data && \
  chown -R electrs.electrs /data

USER electrs

COPY --from=build /electrs/target/release/electrs /usr/local/bin/
COPY resources/* /home/electrs/

CMD [ \
  "/usr/local/bin/electrs", \
  "--conf", "/data/electrs/electrs.conf" \
]
