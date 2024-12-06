FROM alpine:3.20

RUN \
  apk --no-cache add \
    apache-arrow-dev \
    bash \
    bison \
    blosc-dev \
    bsd-compat-headers \
    ca-certificates \
    cmake \
    curl \
    g++ \
    gcc \
    gdb \
    git \
    libedit-dev \
    libevent-dev \
    libstemmer-dev \
    lz4-dev \
    make \
    msgpack-c-dev \
    musl-dev \
    openssl-dev \
    pkgconf \
    rapidjson-dev \
    ruby-dev \
    samurai \
    # simdjson-dev \
    sudo \
    tzdata \
    xsimd-dev \
    xxhash-dev \
    zeromq-dev \
    zlib-dev \
    zstd-dev && \
    update-ca-certificates

WORKDIR /usr/local/src

ENV GROONGA_VERSION=14.1.1

RUN \
  curl -Lo groonga.tar.gz \
    https://packages.groonga.org/source/groonga/groonga-${GROONGA_VERSION}.tar.gz && \
  tar xzf groonga.tar.gz && \
  cmake \
    -Sgroonga-${GROONGA_VERSION} \
    -Bgroonga-${GROONGA_VERSION}.build \
    --preset=release-maximum \
    -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc && \
  cmake --build groonga-${GROONGA_VERSION}.build && \
  DESTDIR=/chroot cmake --install groonga-${GROONGA_VERSION}.build && \
  rm -rf \
    /chroot/usr/include \
    /chroot/usr/lib/cmake \
    /chroot/usr/lib/pkgconfig

FROM alpine:3.20
RUN \
  apk --no-cache add \
    blosc \
    libarrow \
    libedit \
    libevent \
    libstemmer \
    lz4 \
    msgpack-c \
    openssl \
    xsimd \
    xxhash-dev \
    zeromq \
    zlib \
    zstd
COPY --from=0 /chroot/ /
ENTRYPOINT ["groonga"]
