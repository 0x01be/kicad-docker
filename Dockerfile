FROM 0x01be/vtk as vtk

FROM 0x01be/oce as builder

COPY --from=vtk /opt/vtk/ /opt/vtk/ 

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
    py3-wxpython \
    python2-dev \
    jpeg-dev \
    py-pip

RUN pip install \
    wxpython \
    wxpython-common

RUN git clone --depth 1 https://gitlab.com/kicad/code/kicad.git /kicad

RUN mkdir -p /kicad/build
WORKDIR /kicad/build

RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN make
RUN make install

