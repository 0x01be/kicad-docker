FROM alpine as build

ENV REVISION master

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/GlasgowEmbedded/glasgow.git /glasgow

FROM 0x01be/kicad:stable

USER root
COPY --from=build /glasgow/ ${WORKSPACE}/glasgow/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/glasgow/hardware/boards/glasgow/glasgow.pro"

