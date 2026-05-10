FROM ghcr.io/gbdev/rgbds:master AS build
RUN apt-get update && apt-get install -y && \
    apt-get autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
COPY . /usr/local/src/duckdemo-gbc
WORKDIR /usr/local/src/duckdemo-gbc
RUN make build && \
    make test && \
    make package

FROM scratch AS build-export
COPY --from=build /usr/local/src/duckdemo-gbc/build/duckdemo.gb /
WORKDIR /

