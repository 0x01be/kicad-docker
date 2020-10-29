FROM alpine as build

RUN apk add --no-cache --virtual ulx3s-build-dependencies \
    git

ENV REVISION master
ENV PROJECT ulx3s

RUN git clone --depth 1 --branch ${REVISION} https://github.com/emard/ulx3s.git /${PROJECT}

FROM 0x01be/kicad:stable

USER root
COPY --from=build /${PROJECT}/ /home/xpra/${PROJECT}/
RUN chown -R xpra:xpra /home/xpra

USER xpra
ENV COMMAND kicad

