FROM alpine as build

USER root

ENV REVISION main
ENV PROJECT OrangeCrab

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/gregdavill/OrangeCrab.git /${PROJECT}

FROM 0x01be/kicad:stable

COPY --from=build /${PROJECT}/ ${WORKSPACE}/${PROJECT}/

RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad /home/xpra/OrangeCrab/hardware/orangecrab_r0.2.1/OrangeCrab.pro"

