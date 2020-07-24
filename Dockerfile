FROM alpine:3.12.0 as builder

ENV OCE_VERSION official/6.8.0

RUN apk add --no-cache --virtual edge-build-dependencies --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    build-base \
    cmake \
    python3-dev \
    mesa-dev \
    glew-dev \
    glm-dev \
    curl-dev \
    cairo-dev \
    boost-dev \
    ngspice-dev \
    tcl-dev \
    tk-dev \
    zig

RUN git clone --depth 1 --branch $OCE_VERSION https://github.com/tpaviot/oce.git /oce

# https://github.com/tpaviot/oce/issues/675
# https://stackoverflow.com/a/58576593
# https://dev.alpinelinux.org/~clandmeter/other/forum.alpinelinux.org/comment/690.html#comment-690
COPY oce.patch /oce/
WORKDIR /oce
RUN patch -p0 < oce.patch
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN mkdir /oce/build
WORKDIR /oce/build

RUN cmake ..
RUN make
RUN make install

RUN git clone --depth 1 https://gitlab.com/kicad/code/kicad.git /kicad

RUN mkdir -p /kicad/build
WORKDIR /kicad/build

RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
RUN make install

