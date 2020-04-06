FROM tudorh/dosbox:latest

ADD ["tpc.tar.gz", "/tpc/"]
ADD ["js-dos.tar.gz", "index.html", "/web/"]
COPY docker-entrypoint.sh docker-entrypoint.sh

RUN apk add --no-cache zip && chmod +x ./docker-entrypoint.sh

ENV SDL_VIDEODRIVER dummy

ENTRYPOINT [ "/docker-entrypoint.sh" ]
