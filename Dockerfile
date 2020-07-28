FROM 0x01be/swig as swig
FROM 0x01be/oce as oce
FROM 0x01be/wxwidgets as wxwidgets

FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
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
    jpeg-dev \
    gtk+3.0-dev \
    tiff-dev \
    libnotify-dev \
    gstreamer-dev

COPY --from=swig /opt/swig/ /opt/swig/
ENV SWIG_DIR /opt/swig
ENV PATH $PATH:/opt/swig/bin/

COPY --from=oce /opt/oce/ /opt/oce/

COPY --from=wxwidgets /opt/wxwidgets/ /opt/wxwidgets/
ENV wxWidgets_ROOT_DIR /opt/wxwidgets/
ENV PATH $PATH:/opt/wxwidgets/bin/

RUN git clone --depth 1 https://gitlab.com/kicad/code/kicad.git /kicad

RUN mkdir -p /kicad/build
WORKDIR /kicad/build

RUN cmake -DCMAKE_BUILD_TYPE=Release \
    -DKICAD_SCRIPTING_PYTHON3=ON \
    -DKICAD_SCRIPTING_WXPYTHON=OFF \
    -DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON \
    -DOCE_DIR=/opt/oce/  \
    -DwxWidgets_ROOT_DIR=/opt/wxwidgets/ \
     ..
RUN make
RUN make install

