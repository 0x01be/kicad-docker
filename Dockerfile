FROM alpine as build

RUN apk add --no-cache --virtual fx2grok-build-dependencies \
    git

ENV REVISION master
ENV PROJECT fx2grok

RUN git clone --depth 1 --branch ${REVISION} git://sigrock.com/fx2grok /${PROJECT}

FROM 0x01be/kicad:stable

USER root
COPY --from=build /${PROJECT}/ /home/xpra/${PROJECT}/
RUN chown -R xpra:xpra /home/xpra

ENV COMMAND kicad

