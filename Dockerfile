FROM 0x01be/swig:4.0 as swig
FROM 0x01be/oce as oce

FROM alpine as builder

RUN apk add --no-cache --virtual kicad-build-dependencies \
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
    tcl-dev \
    tk-dev \
    jpeg-dev \
    gtk+3.0-dev \
    tiff-dev \
    libnotify-dev \
    gstreamer-dev

RUN apk add --no-cache --virtual kicad-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    ngspice-dev \
    wxgtk3-dev \
    py3-wxpython

COPY --from=oce /opt/oce/ /opt/oce/
COPY --from=swig /opt/swig/ /opt/swig/

ENV SWIG_DIR /opt/swig
ENV PATH $PATH:$SWIG_DIR/bin/
ENV LD_RUN_PATH /usr/lib/:/usr/bin/:${SWIG_DIR}/bin/

ENV KICAD_REVISION master

RUN git clone --depth 1 --branch ${KICAD_REVISION} https://gitlab.com/kicad/code/kicad.git /kicad

RUN mkdir -p /kicad/build
WORKDIR /kicad/build

# https://kicad.readthedocs.io/en/stable/Documentation/development/compiling/
# https://docs.kicad-pcb.org/doxygen/md_Documentation_development_compiling.html
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/kicad \
    -DCMAKE_BUILD_TYPE=Release \
    -DKICAD_SPICE=ON \
    -DKICAD_SCRIPTING=ON \
    -DKICAD_SCRIPTING_MODULES=ON \
    -DKICAD_SCRIPTING_PYTHON3=ON \
    -DKICAD_SCRIPTING_WXPYTHON=ON \
    -DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON \
    -DKICAD_SCRIPTING_ACTION_MENU=ON \
    -DBUILD_GITHUB_PLUGIN=ON \
    -DKICAD_USE_OCE=ON \
    -DKICAD_USE_OCC=OFF \
    -DKICAD_USE_VALGRIND=OFF \
    -DKICAD_STDLIB_DEBUG=OFF \
    -DKICAD_STDLIB_LIGHT_DEBUG=OFF \
    -DKICAD_SANITIZE=OFF \
    -DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-gtk3 \
    -DOCE_DIR=/opt/oce/ \
     ..
RUN make install

FROM 0x01be/xpra

COPY --from=builder /opt/kicad/ /opt/kicad/

USER root
RUN apk add --no-cache --virtual kicad-runtime-dependencies \
    python3 \
    mesa \
    glew \
    glm \
    cairo \
    tk \
    jpeg \
    tiff \
    libnotify \
    gstreamer

RUN apk add --no-cache --virtual kicad-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    ngspice \
    py3-wxpython

USER xpra

WORKDIR /workspace

ENV COMMAND "kicad"

