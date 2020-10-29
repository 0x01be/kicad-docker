FROM alpine as build

RUN apk add --no-cache --virtual ulx3s-build-dependencies \
    git

ENV REVISION master
ENV PROJECT /ulx3s

RUN git clone --depth 1 --branch ${REVISION} https://github.com/emard/ulx3s.git ${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build ${PROJECT} /home/xpra${PROJECT}

ENV COMMAND kicad

