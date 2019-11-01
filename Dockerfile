FROM alpine:3.8

RUN apk --no-cache add make g++ musl-dev curl \
  jemalloc zeromq libevent msgpack-c-dev ca-certificates && \
  update-ca-certificates

WORKDIR /usr/local/src

ENV CFLAGS -g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security
ENV LDFLAGS -Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now
ENV CPPFLAGS -Wdate-time -D_FORTIFY_SOURCE=2
ENV CXXFLAGS -g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security
ENV VERSION 8.1.0

RUN curl -Lo groonga.tar.gz \
  http://packages.groonga.org/source/groonga/groonga-$VERSION.tar.gz && \
  tar xzf groonga.tar.gz && cd groonga-$VERSION && \
  ./configure --prefix=/usr \
    --disable-maintainer-mode --disable-dependency-tracking \
    --disable-groonga-httpd && \
  make && make DESTDIR=/chroot install

FROM alpine:3.8
RUN apk --no-cache add jemalloc zeromq libevent msgpack-c
COPY --from=0 /chroot/ /
ENTRYPOINT ["groonga"]
