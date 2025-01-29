FROM debian:bookworm

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

ENV GROONGA_VERSION=14.1.3-1

RUN \
  apt update && \
  apt install -y -V ${quiet} \
    ca-certificates \
    lsb-release \
    wget && \
  wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
  apt install -y -V ${quiet} ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
  rm ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
  wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
  apt install -y -V ${quiet} ./groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
  rm ./groonga-apt-source-latest-$(lsb_release --codename --short).deb && \
  apt update && \
  apt install -y \
    groonga-bin=${GROONGA_VERSION} \
    groonga-normalizer-mysql \
    groonga-plugin-suggest=${GROONGA_VERSION} \
    groonga-server-common=${GROONGA_VERSION} \
    groonga-token-filter-stem=${GROONGA_VERSION} \
    groonga-tokenizer-mecab=${GROONGA_VERSION} \
    libgroonga0=${GROONGA_VERSION} \
    sudo \
    zstd \
    zutils && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 10041

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
