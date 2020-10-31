FROM alpine as build

ENV REVISION master

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/emard/ulx3s.git /ulx3s

FROM 0x01be/kicad:stable

USER root
COPY --from=build /ulx3s/ ${WORKSPACE}/ulx3s/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/ulx3s/ulx3s.pro"

