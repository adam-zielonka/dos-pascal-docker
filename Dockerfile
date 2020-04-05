# docker build -t registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker .
# docker push registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker
FROM tudorh/dosbox:latest

RUN apk update && apk add zip

ENV SDL_VIDEODRIVER dummy

RUN mkdir /tp
COPY 3rd-party/TPWDB.ZIP TPWDB.ZIP
RUN unzip TPWDB.ZIP -d /tp

RUN mkdir /web
COPY 3rd-party/js-dos.zip js-dos.zip
RUN unzip js-dos.zip -d /web
COPY index.html /web/index.html

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
