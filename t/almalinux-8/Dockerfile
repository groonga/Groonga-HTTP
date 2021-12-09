ARG FROM=almalinux:8
FROM ${FROM}

ARG DEBUG

RUN \
  quiet=$([ "${DEBUG}" = "yes" ] || echo "--quiet") && \
  dnf update -y ${quiet} && \
  dnf install -y ${quiet} \
    epel-release \
    'dnf-command(config-manager)' \
    https://packages.groonga.org/almalinux/8/groonga-release-latest.noarch.rpm && \
  dnf config-manager --set-enabled powertools && \
  dnf install -y --enablerepo=epel --enablerepo=powertools groonga install groonga-tokenizer-mecab && \
  dnf groupinstall -y ${quiet} "Development Tools" && \
  dnf install -y ${quiet} \
    arrow-devel \
    libedit-devel \
    libevent-devel \
    libstemmer-devel \
    libzstd-devel \
    lz4-devel \
    mecab-devel \
    msgpack-devel \
    pkgconfig \
    ruby \
    tar \
    xxhash-devel \
    zlib-devel && \
  dnf clean ${quiet} all && \
  cpanm Test2::Suite  
