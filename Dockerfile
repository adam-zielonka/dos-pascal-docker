FROM alpine:3.24

ENV SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy

ADD ["bin/tpc.tar.gz", "/tpc/"]
ADD ["bin/js-dos.tar.gz", "index.html", "/web/"]
ADD ["bin/iconv.tar.gz", "/usr/local/"]
ADD ["bin/dosbox.tar.gz", "/usr/local/bin/"]

RUN apk add --no-cache zip sdl12-compat libxxf86vm libstdc++ libgcc file inotify-tools

ADD [ \
  "scripts/docker-entrypoint.sh", \
  "scripts/encode.sh", \
  "scripts/decode.sh", \
  "scripts/compile.sh", \
  "scripts/website.sh", \
  "/usr/local/bin/" \
]

ENTRYPOINT [ "docker-entrypoint.sh" ]

COPY tests/smoke.sh /usr/local/bin/smoke-test.sh
RUN chmod +x /usr/local/bin/smoke-test.sh
