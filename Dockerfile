FROM 0x01be/kicad:build as build

FROM 0x01be/xpra

COPY --from=build /opt/kicad/ /opt/kicad/
ENV PATH $PATH:/opt/kicad/bin/
ENV LD_LIBRARY_PATH /usr/lib/:/opt/kicad/lib/

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

