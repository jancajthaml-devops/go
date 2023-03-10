# Copyright (c) 2017-2023, Jan Cajthaml <jan.cajthaml@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ---------------------------------------------------------------------------- #

FROM --platform=linux/amd64 amd64/debian:sid-slim

ENV container docker
ENV LANG C.UTF-8
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE no
ENV LDFLAGS "-Wl,-z,-now -Wl,-z,relro"
ENV GOFLAGS -buildmode=pie
ENV CGO_ENABLED 1
ENV GOLANG_VERSION 1.20.2
ENV GOSEC_VERSION 2.15.0
ENV LIBRARY_PATH /usr/lib
ENV LD_LIBRARY_PATH /usr/lib
ENV GOROOT /usr/local/go
ENV CGO_ENABLED 1
ENV GO111MODULE on
ENV GOPATH /go
ENV GOARCH amd64
ENV GOOS linux
ENV GOHOSTOS linux
ENV CC gcc
ENV CXX g++
ENV PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"
ENV XDG_CONFIG_HOME /usr/share

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture amd64
RUN dpkg --add-architecture arm64

RUN \
    echo "installing debian packages" && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      wget \
      git \
      grc \
      tar \
      pkg-config \
      gcc \
      gcc-arm-linux-gnueabi \
      gcc-arm-linux-gnueabihf \
      gcc-aarch64-linux-gnu \
      g++ \
      g++-arm-linux-gnueabi \
      g++-arm-linux-gnueabihf \
      g++-aarch64-linux-gnu \
      libc6 \
      libc6-armhf-cross \
      libc6-dev \
      libc6-dev-armhf-cross \
      libzmq5:amd64>=4.3~~ \
      libzmq5:armhf>=4.3~~ \
      libzmq5:arm64>=4.3~~ \
      libzmq3-dev:amd64>=4.3~~ \
      libzmq3-dev:armhf>=4.3~~ \
      libzmq3-dev:arm64>=4.3~~ && \
    \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    :

RUN \
    echo "installing go ${GOLANG_VERSION}" && \
    \
    wget -O - -o /dev/null \
      "https://golang.org/dl/go${GOLANG_VERSION}.${GOHOSTOS}-${GOARCH}.tar.gz" | tar xzf - -C /usr/local && \
      chmod +x "${GOROOT}"/bin/go && \
      chmod +x "${GOROOT}"/bin/gofmt && \
    \
    wget -O /usr/bin/go2xunit -o /dev/null \
      "https://github.com/tebeka/go2xunit/releases/download/v1.4.10/go2xunit-${GOHOSTOS}-${GOARCH}" && \
      chmod +x /usr/bin/go2xunit && \
    \
    wget -O - -o /dev/null \
      "https://github.com/securego/gosec/releases/download/v${GOSEC_VERSION}/gosec_${GOSEC_VERSION}_${GOHOSTOS}_${GOARCH}.tar.gz" | tar xzf - -C /usr/bin && \
    :

RUN \
    echo "installing go packages" && \
    go install -v std && \
    go install -v golang.org/x/lint/golint@latest && \
    go install -v github.com/fzipp/gocyclo/cmd/gocyclo@latest && \
    go install -v github.com/client9/misspell/cmd/misspell@latest && \
    go install -v github.com/alexkohler/prealloc@latest && \
    go install -v github.com/mdempsky/maligned@latest && \
    go install -v github.com/jgautheron/goconst/cmd/goconst@latest && \
    go install -v github.com/gordonklaus/ineffassign@latest && \
    :

COPY grc/grc.conf /usr/share/grc/grc.conf

COPY grc/conf.gotest /usr/share/grc/conf.gotest

ENTRYPOINT [ "go" ]
