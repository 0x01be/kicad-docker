FROM alpine as build

RUN apk add --no-cache --virtual fx2grok-build-dependencies \
    git

ENV REVISION master
ENV PROJECT /fx2grok

RUN git clone --depth 1 --branch ${REVISION} git://sigrock.com/fx2grok ${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build ${PROJECT} /home/xpra${PROJECT}

ENV COMMAND kicad

