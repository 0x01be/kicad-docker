FROM alpine as build

ENV REVISION master

RUN apk add --no-cache git && git clone --recursive --branch ${REVISION} https://github.com/daveshah1/TrellisBoard.git /TrellisBoard

FROM 0x01be/kicad:stable

USER root
COPY --from=build /TrellisBoard/ ${WORKSPACE}/TrellisBoard/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/TrellisBoard/hardware/ecp5_mainboard/ecp5_mainboard.pro"

