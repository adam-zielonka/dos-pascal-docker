FROM alpine:edge

ENV SDL_VIDEODRIVER dummy

ADD ["bin/tpc.tar.gz", "/tpc/"]
ADD ["bin/js-dos.tar.gz", "index.html", "/web/"]
ADD ["bin/iconv.tar.gz", "/usr/local/"]
ADD ["bin/dosbox.tar.gz", "/usr/local/bin/"]

RUN apk add --no-cache zip sdl libxxf86vm libstdc++ libgcc file inotify-tools

ADD ["scripts/docker-entrypoint.sh", "scripts/encode.sh", "scripts/decode.sh", "scripts/compile.sh", "/usr/local/bin/"]

ENTRYPOINT [ "docker-entrypoint.sh" ]
