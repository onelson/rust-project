FROM theomn/rustup-base:latest as builder

# Stage 1: produce static binaries

# Based loosely on a combination of:
# * https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly_musl/Dockerfile
# * https://github.com/emk/rust-musl-builder/blob/master/Dockerfile

WORKDIR /root

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates curl file \
    build-essential musl-tools \
    autoconf automake autotools-dev libtool xutils-dev && \
    rm -rf /var/lib/apt/lists/*

# Build a static library version of OpenSSL using musl-libc.  This is
# needed by the popular Rust `hyper` crate.
# Note: the $SSL_VERSION var is set in rustup-base
RUN echo "Building OpenSSL" && \
    VERS=$SSL_VERSION && \
    curl -O https://www.openssl.org/source/openssl-$VERS.tar.gz && \
    tar xvzf openssl-$VERS.tar.gz && cd openssl-$VERS && \
    env CC=musl-gcc ./Configure no-shared no-zlib -fPIC --prefix=/usr/local/musl linux-x86_64 && \
    env C_INCLUDE_PATH=/usr/local/musl/include/ make depend && \
    make && make install && \
    cd .. && rm -rf openssl-$VERS.tar.gz openssl-$VERS

# Any other native deps needed for your binary should be built for 
# static linking here...

# Add all the env required to configure the static build.
ENV OPENSSL_DIR=/usr/local/musl/ \
    OPENSSL_INCLUDE_DIR=/usr/local/musl/include/ \
    DEP_OPENSSL_INCLUDE=/usr/local/musl/include/ \
    OPENSSL_LIB_DIR=/usr/local/musl/lib/ \
    OPENSSL_STATIC=1 \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true

RUN rustup target add x86_64-unknown-linux-musl \
    && echo "[build]\ntarget = \"x86_64-unknown-linux-musl\"" > $CARGO_HOME/config

ENV RUST_BACKTRACE=1

ADD . /code
WORKDIR /code

RUN cargo clean && cargo build --all --release

# Stage 2: Add to a small deploy container

FROM scratch
# Borrow the ca certs from the builder
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# You'd also want to copy whatever your binaries are called
COPY --from=builder /code/target/x86_64-unknown-linux-musl/release/my-binary .
ENTRYPOINT ["./my-binary"]

