# Copyright (c) 2017-2018, Jan Cajthaml <jan.cajthaml@gmail.com>
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

FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    GOLANG_VERSION=1.11.4 \
    LIBRARY_PATH=/usr/lib \
    LD_LIBRARY_PATH=/usr/lib \
    GOROOT=/usr/local/go \
    CGO_ENABLED=1 \
    GOPATH=/go \
    GOARCH=amd64 \
    GOOS=linux \
    GOHOSTOS=linux \
    CC=gcc \
    CXX=g++

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture amd64
RUN dpkg --add-architecture arm64

RUN apt-get update && \
    \
    echo "installing essentials" && \
    apt-get install -y --no-install-recommends \
      apt-utils \
      curl \
      ca-certificates \
      && \
    \
    echo "installing debian packages" && \
    apt-get -y install --no-install-recommends \
      git \
      tar \
      cmake \
      make \
      patch \
      python \
      debhelper \
      config-package-dev \
      fakeroot \
      pkg-config \
      libsystemd-dev \
      gcc \
      gcc-arm-linux-gnueabi \
      gcc-arm-linux-gnueabihf \
      g++ \
      g++-arm-linux-gnueabi \
      g++-arm-linux-gnueabihf \
      libc6 \
      libc6-armhf-cross \
      libc6-dev \
      libc6-dev-armhf-cross \
      \
      libzmq5:amd64>=4.2.1~ \
      libzmq5:armhf>=4.2.1~ \
      libzmq5:arm64>=4.2.1~ \
      libzmq3-dev:amd64>=4.2.1~ \
      libzmq3-dev:armhf>=4.2.1~ \
      libzmq3-dev:arm64>=4.2.1~ \
      \
      && \
    \
    echo "installing go ${GOLANG_VERSION}" && \
    curl -sL "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" | tar xzf - -C /usr/local && \
      mv "${GOROOT}"/bin/go /usr/bin/go && \
      mv "${GOROOT}"/bin/godoc /usr/bin/godoc && \
      mv "${GOROOT}"/bin/gofmt /usr/bin/gofmt && \
    \
    curl -sL https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -o /usr/bin/dep && \
      chmod +x /usr/bin/dep && \
    \
    curl -sL https://github.com/Masterminds/glide/releases/download/v0.13.1/glide-v0.13.1-linux-amd64.tar.gz | tar xzf - -C /usr/lib && \
      mv /usr/lib/linux-amd64/glide /usr/bin/glide && \
    \
    curl -sL https://github.com/securego/gosec/releases/download/1.2.0/gosec_1.2.0_linux_amd64.tar.gz | tar xzf - -C /usr/bin && \
    \
    go get -u \
      \
      golang.org/x/lint/golint \
      github.com/fzipp/gocyclo \
      github.com/client9/misspell/cmd/misspell \
      github.com/alexkohler/prealloc \
      github.com/mdempsky/maligned \
      github.com/jgautheron/goconst/cmd/goconst \
      && \
    \
    rm -rf /var/lib/apt/lists/* /tmp/*
