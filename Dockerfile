FROM alpine as build

ENV REVISION master
ENV PROJECT fx2grok

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} git://sigrok.org/fx2grok /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ /home/xpra/${PROJECT}/
RUN chown -R xpra:xpra /home/xpra

USER xpra
ENV COMMAND kicad

