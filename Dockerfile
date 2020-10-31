FROM alpine as build

ENV REVISION master
ENV PROJECT YardStickOne

RUN apk add --no-cache git && git clone --depth 1 --branch ${REVISION} https://github.com/greatscottgadgets/yardstick.git /${PROJECT}

FROM 0x01be/kicad:stable

USER root
COPY --from=build /YardStickOne ${WORKSPACE}/YardStickOne/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV COMMAND "kicad ${WORKSPACE}/YardStickOne/yardstickone/yardstickone.pro"

