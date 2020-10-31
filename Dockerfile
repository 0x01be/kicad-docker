FROM alpine as build

ENV REVISION main

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/gregdavill/OrangeCrab.git /OrangeCrab

FROM 0x01be/kicad:stable

USER root
COPY --from=build /OrangeCrab/ ${WORKSPACE}/OrangeCrab/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/OrangeCrab/hardware/orangecrab_r0.2.1/OrangeCrab.pro"

