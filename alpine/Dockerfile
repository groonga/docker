FROM alpine:3.12

RUN apk --no-cache add \
  ca-certificates \
  curl \
  g++ \
  libevent \
  make \
  msgpack-c-dev \
  musl-dev \
  zeromq && \
  update-ca-certificates

WORKDIR /usr/local/src

ENV CFLAGS -g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security
ENV LDFLAGS -Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now
ENV CPPFLAGS -Wdate-time -D_FORTIFY_SOURCE=2
ENV CXXFLAGS -g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security
ENV GROONGA_VERSION=11.0.3

RUN \
  curl -Lo groonga.tar.gz \
    https://packages.groonga.org/source/groonga/groonga-$GROONGA_VERSION.tar.gz && \
  tar xzf groonga.tar.gz && \
  cd groonga-$GROONGA_VERSION && \
  ./configure \
    --disable-dependency-tracking \
    --disable-groonga-httpd \
    --disable-maintainer-mode \
    --prefix=/usr && \
  make -j$(nproc) && \
  make DESTDIR=/chroot install

FROM alpine:3.12
RUN apk --no-cache add zeromq libevent msgpack-c
COPY --from=0 /chroot/ /
ENTRYPOINT ["groonga"]
