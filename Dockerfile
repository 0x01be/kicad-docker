FROM 0x01be/xpra

USER root
RUN apk add --no-cache --virtual kicad-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    ngspice \
    kicad \
    kicad-library \
    kicad-library-3d \
    kicad-i18n \
    kicad-doc

USER xpra

ENV COMMAND "kicad"

