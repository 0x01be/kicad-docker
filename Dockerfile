FROM alpine as build

ENV REVISION master
ENV PROJECT ulx3s

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/emard/ulx3s.git /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ ${WORKSPACE}/${PROJECT}/

RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/${PROJECT}/ulx3s.pro"

