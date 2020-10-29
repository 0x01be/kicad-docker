FROM alpine as build

ENV REVISION master
ENV PROJECT YardStickOne

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/greatscottgadgets/yardstick.git /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ /home/xpra/${PROJECT}/
USER root
RUN chown -R xpra:xpra /home/xpra

USER xpra
ENV COMMAND kicad

