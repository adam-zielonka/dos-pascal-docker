FROM tudorh/dosbox:latest

RUN apk update && apk add zip

ENV SDL_VIDEODRIVER dummy
RUN mkdir /root/.dosbox
COPY docker/dosbox-0.74-2.conf /root/.dosbox/dosbox-0.74-2.conf
RUN mkdir /tp
COPY 3rd-party/TPWDB.ZIP TPWDB.ZIP
RUN unzip TPWDB.ZIP -d /tp
COPY docker/docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

WORKDIR /var/www
ENTRYPOINT [ "/docker-entrypoint.sh" ]
