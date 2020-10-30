FROM alpine as build

ENV REVISION master
ENV PROJECT fx2grok

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} git://sigrok.org/fx2grok /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ ${WORKSPACE}/${PROJECT}/

RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/${PROJECT}/hardware/fx2grok-flat/0.3/fx2grok-flat.pro"

