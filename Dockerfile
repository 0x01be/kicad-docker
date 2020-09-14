FROM 0x01be/kicad:build as build

ENV PATH $PATH:/opt/kicad/bin/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/kicad/share/kicad/scripting/
ENV LD_LIBRARY_PATH /usr/lib/:/opt/kicad/lib/

RUN git clone --depth 1 https://github.com/INTI-CMNB/kicad-automation-scripts /kicad-automation-scripts

WORKDIR /kicad-automation-scripts

RUN python3 setup.py install --home=/opt/kicad

FROM 0x01be/xpra

COPY --from=build /opt/kicad/ /opt/kicad/
ENV PATH $PATH:/opt/kicad/bin/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/kicad/share/kicad/scripting/:/opt/kicad/lib/python/
ENV LD_LIBRARY_PATH /usr/lib/:/opt/kicad/lib/

USER root
RUN apk add --no-cache --virtual kicad-runtime-dependencies \
    python3 \
    py3-yaml \
    curl \
    mesa \
    glew \
    glm \
    glu \
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

