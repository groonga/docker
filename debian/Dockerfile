FROM debian:buster

ENV GROONGA_VERSION=11.0.2-1

RUN \
  apt update && \
  apt install -y wget && \
  wget https://packages.groonga.org/debian/groonga-apt-source-latest-buster.deb && \
  apt install -y -V ./groonga-apt-source-latest-buster.deb && \
  rm -f groonga-apt-source-latest-buster.deb && \
  apt update && \
  apt install -y \
    groonga-bin=${GROONGA_VERSION} \
    groonga-doc=${GROONGA_VERSION} \
    groonga-normalizer-mysql \
    groonga-plugin-suggest=${GROONGA_VERSION} \
    groonga-server-common=${GROONGA_VERSION} \
    groonga-token-filter-stem=${GROONGA_VERSION} \
    groonga-tokenizer-mecab=${GROONGA_VERSION} \
    groonga=${GROONGA_VERSION} \
    libgroonga0=${GROONGA_VERSION} \
    sudo \
    zstd \
    zutils && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 10041

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
