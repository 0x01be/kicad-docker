FROM alpine as build

ENV REVISION master

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/gregdavill/ButterStick.git /butter

FROM 0x01be/kicad:stable

USER root
COPY --from=build /butter/ ${WORKSPACE}/butter/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/butter/hardware/ButterStick_r1.0/ButterStick.kicad_pro"

