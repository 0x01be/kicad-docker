FROM 0x01be/kicad:build as build

FROM 0x01be/xpra

USER root
RUN apk add --no-cache --virtual kicad-runtime-dependencies \
    python3 \
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

RUN mkdir -p /tmp/.X11-unix

USER xpra

COPY --from=build /opt/kicad/ /opt/kicad/

ENV PATH $PATH:/opt/kicad/bin/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/kicad/share/kicad/scripting/
ENV LD_LIBRARY_PATH /usr/lib/:/opt/kicad/lib/

ENV COMMAND kicad

