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
    GOLANG_VERSION=1.11.2 \
    LIBRARY_PATH=/usr/lib \
    LD_LIBRARY_PATH=/usr/lib \
    GOPATH=/go \
    CGO_ENABLED=1 \
    GOPATH=/go \
    GOARCH=amd64 \
    GOOS=linux \
    GOHOSTOS=linux \
    CC=gcc \
    CXX=g++

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture amd64

RUN apt-get update && \
    \
    apt-get install -y --no-install-recommends \
      apt-utils \
      ca-certificates>=20161130 \
      && \
    \
    apt-get -y install --no-install-recommends \
      git>=1:2.11.0-3 \
      curl>=7.52.1-5 \
      tar=1.29b-1.1 \
      cmake=3.7.2-1 \
      make=4.1-9.1 \
      patch>=2.7.5-1 \
      python=2.7.13-2 \
      debhelper=10.2.5 \
      config-package-dev=5.1.2 \
      fakeroot=1.21-3.1 \
      pkg-config>=0.29-4 \
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
      libzmq3-dev:amd64=4.2.1-4 \
      libzmq3-dev:armhf=4.2.1-4 \
      && \
    \
    curl -sL "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" | tar xzf - -C /usr/local && \
      mv /usr/local/go/bin/go /usr/bin/go && \
      mv /usr/local/go/bin/godoc /usr/bin/godoc && \
      mv /usr/local/go/bin/gofmt /usr/bin/gofmt && \
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
      github.com/jgautheron/goconst/cmd/goconst && \
    \
    rm -rf /var/lib/apt/lists/* /tmp/*
