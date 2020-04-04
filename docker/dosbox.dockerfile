# docker build -f docker/dosbox.dockerfile -t registry.gitlab.com/adam-zielonka-pro/deska .
# docker push registry.gitlab.com/adam-zielonka-pro/deska
FROM tudorh/dosbox:latest

RUN apk update && apk add zip

ENV SDL_VIDEODRIVER dummy

RUN mkdir /tp
COPY 3rd-party/TPWDB.ZIP TPWDB.ZIP
RUN unzip TPWDB.ZIP -d /tp

RUN mkdir /web
COPY 3rd-party/js-dos.zip js-dos.zip
RUN unzip js-dos.zip -d /web
COPY docker/index.html /web/index.html

COPY docker/docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
