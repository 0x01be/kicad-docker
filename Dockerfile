FROM alpine as build

ENV REVISION master

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} git://sigrok.org/fx2grok /fx2grok

FROM 0x01be/kicad:stable

USER root
COPY --from=build /fx2grok/ ${WORKSPACE}/fx2grok/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/fx2grok/hardware/fx2grok-flat/0.3/fx2grok-flat.pro"

