FROM alpine:latest

RUN apk add --no-cache git build-base cmake libuv-dev openssl-dev hwloc-dev && \
    git clone https://github.com/xmrig/xmrig.git && \
    mkdir xmrig/build && \
    cd xmrig/build && \
    cmake .. && \
    make -j$(nproc) && \
    apk del git build-base cmake && \
    rm -rf /var/cache/apk/*

# Copy config.json to /xmrig/build
# COPY config.json /xmrig/build/

WORKDIR /xmrig/build

ENTRYPOINT ["./xmrig"]
