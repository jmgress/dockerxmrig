ARG ALPINE_VERSION=3.22
ARG XMRIG_VERSION=v6.26.0
ARG XMRIG_TARBALL_SHA256=5005144e78571f26586410c2b2ede2b0c72afe22f97f1708ea24cfb253c3939b

FROM alpine:${ALPINE_VERSION} AS builder
ARG XMRIG_VERSION
ARG XMRIG_TARBALL_SHA256

RUN apk add --no-cache \
    build-base \
    ca-certificates \
    cmake \
    hwloc-dev \
    libuv-dev \
    openssl-dev \
    wget

WORKDIR /src/xmrig

RUN wget -O /tmp/xmrig.tar.gz "https://github.com/xmrig/xmrig/archive/refs/tags/${XMRIG_VERSION}.tar.gz" \
    && echo "${XMRIG_TARBALL_SHA256}  /tmp/xmrig.tar.gz" | sha256sum -c - \
    && tar --strip-components=1 -xzf /tmp/xmrig.tar.gz -C /src/xmrig \
    && cmake -S /src/xmrig -B /src/xmrig/build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build /src/xmrig/build -j"$(nproc)" \
    && strip /src/xmrig/build/xmrig

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    ca-certificates \
    hwloc \
    libgcc \
    libstdc++ \
    libuv \
    openssl

COPY --from=builder /src/xmrig/build/xmrig /usr/local/bin/xmrig

WORKDIR /config
ENTRYPOINT ["/usr/local/bin/xmrig"]
