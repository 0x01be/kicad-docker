FROM alpine as build

ENV REVISION master
ENV PROJECT TrellisBoard

RUN apk add --no-cache git && git clone --recursive --branch ${REVISION} https://github.com/daveshah1/TrellisBoard.git /${PROJECT}

FROM 0x01be/kicad:stable

USER root
COPY --from=build /${PROJECT}/ ${WORKSPACE}/${PROJECT}/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/${PROJECT}/hardware/ecp5_mainboard/ecp5_mainboard.pro

