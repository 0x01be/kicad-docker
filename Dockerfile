FROM 0x01be/swig:4.0 as swig
FROM 0x01be/wxwidgets as wxwidgets
FROM 0x01be/oce as oce

FROM 0x01be/ninja as builder

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
    ngspice-dev

COPY --from=oce /opt/oce/ /opt/oce/
COPY --from=swig /opt/swig/ /opt/swig/
COPY --from=wxwidgets /opt/wxwidgets/ /opt/wxwidgets/

ENV SWIG_DIR /opt/swig

ENV wxWidgets_ROOT_DIR /opt/wxwidgets
ENV wxWidgets_LIB_DIR ${wxWidgets_ROOT_DIR}/lib
ENV wxWidgets_CONFIG_EXECUTABLE ${wxWidgets_ROOT_DIR}/bin/wx-config
ENV wxWidgets_USE_UNICODE ON
ENV wxWidgets_CONFIG_OPTIONS "--toolkit=gtk3 --prefix=${wxWidgets_ROOT_DIR}"

ENV PATH $PATH:$SWIG_DIR/bin/:${wxWidgets_ROOT_DIR}/bin/
ENV LD_LIBRARY_PATH /usr/lib/:${wxWidgets_ROOT_DIR}/lib/
ENV LD_RUN_PATH /usr/lib/:/usr/bin/:${wxWidgets_ROOT_DIR}/bin/:${wxWidgets_ROOT_DIR}/lib/:${SWIG_DIR}/bin/

RUN git clone --depth 1 https://gitlab.com/kicad/code/kicad.git /kicad

RUN mkdir -p /kicad/build
WORKDIR /kicad/build

RUN ${wxWidgets_ROOT_DIR}/bin/wx-config --version

# https://kicad.readthedocs.io/en/stable/Documentation/development/compiling/
# https://docs.kicad-pcb.org/doxygen/md_Documentation_development_compiling.html
RUN cmake \
    -G Ninja \
    -DCMAKE_INSTALL_PREFIX=/opt/kicad \
    -DCMAKE_BUILD_TYPE=Release \
    -DKICAD_SCRIPTING=OFF \
    -DKICAD_SCRIPTING_MODULES=OFF \
    -DKICAD_SCRIPTING_PYTHON3=OFF \
    -DKICAD_SCRIPTING_WXPYTHON=OFF \
    -DKICAD_SCRIPTING_ACTION_MENU=OFF \
    -DBUILD_GITHUB_PLUGIN=OFF \
    -DKICAD_USE_OCE=ON \
    -DKICAD_USE_OCC=OFF \
    -DKICAD_SPICE=ON \
    -DKICAD_STDLIB_DEBUG=OFF \
    -DKICAD_STDLIB_LIGHT_DEBUG=OFF \
    -DKICAD_SANITIZE=OFF \
    -DKICAD_USE_VALGRIND=OFF \
    -DwxWidgets_CONFIG_OPTIONS="${wxWidgets_CONFIG_OPTIONS}" \
    -DwxWidgets_ROOT_DIR="${wxWidgets_ROOT_DIR}" \
    -DwxWidgets_LIB_DIR="${wxWidgets_LIB_DIR}" \
    -DwxWidgets_CONFIG_EXECUTABLE=${wxWidgets_CONFIG_EXECUTABLE} \
    -DwxWidgets_USE_UNICODE="${wxWidgets_USE_UNICODE}" \
    -DOCE_DIR=/opt/oce/ \
     ..
RUN ninja

