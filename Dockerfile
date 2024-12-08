FROM ubuntu:24.04

# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md#run---mounttypecache
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata && \
    apt install -y --no-install-recommends nano ca-certificates curl python3 python3-pip python3-venv aspell aspell-en && \
    apt -y upgrade && \
    apt autoremove -y

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# https://github.com/cooklang/cookcli/releases
# 'musl' is statically linked, 'gnu' is dynamically linked
# RUN curl -LO https://github.com/cooklang/cookcli/releases/latest/download/cook-x86_64-unknown-linux-musl.tar.gz && \
#     tar -zxvf cook-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin && \
#     rm -rf cook-x86_64-unknown-linux-musl.tar.gz

# This web-ui seems more feature-rich than the official cooklang one.
# https://github.com/Zheoni/cooklang-chef/releases
# 'musl' is statically linked, 'gnu' is dynamically linked
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        BINARY_URL="https://github.com/Zheoni/cooklang-chef/releases/latest/download/chef-x86_64-unknown-linux-gnu.tar.gz"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        BINARY_URL="https://github.com/Zheoni/cooklang-chef/releases/latest/download/chef-aarch64-unknown-linux-gnu.tar.gz"; \
    else \
        echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    curl -LO "$BINARY_URL" && \
    tar -zxvf $(basename "$BINARY_URL") -C /usr/local/bin && \
    rm -rf $(basename "$BINARY_URL")

#RUN mkdir -p /recipes

#COPY recipes /recipes/

COPY check-spelling.py /

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s \
   CMD curl --fail localhost:9080 || exit 1

WORKDIR /

# https://github.com/Zheoni/cooklang-chef/blob/main/docs/cli.md#configuration
# see chef config --setup
#COPY config.toml /recipes/.cooklang/config.toml

#ENTRYPOINT ["cook", "server", "--host", "./recipes"]
ENTRYPOINT ["chef", "serve", "--host", "--port", "9080", "--path", "./recipes"]
#ENTRYPOINT [ "tail", "-f", "/dev/null" ]