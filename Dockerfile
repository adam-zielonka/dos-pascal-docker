FROM alpine:edge

ENV SDL_VIDEODRIVER dummy

ADD ["tpc.tar.gz", "/tpc/"]
ADD ["js-dos.tar.gz", "index.html", "/web/"]
ADD ["dosbox.tar.gz", "/usr/bin/"]

RUN apk add --no-cache zip sdl libxxf86vm libstdc++ libgcc file

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
