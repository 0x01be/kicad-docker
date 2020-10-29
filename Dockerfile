FROM alpine as build

ENV REVISION master
ENV PROJECT ulx3s

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/emard/ulx3s.git /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ /home/xpra/${PROJECT}/
USER root
RUN chown -R xpra:xpra /home/xpra

USER xpra
ENV COMMAND kicad

