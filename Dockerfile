FROM alpine:edge

ENV SDL_VIDEODRIVER dummy

ADD ["tpc.tar.gz", "/tpc/"]
ADD ["js-dos.tar.gz", "index.html", "/web/"]
ADD ["dosbox-0.74-3.tar.gz", "/build/"]

RUN apk add --no-cache zip sdl libxxf86vm libstdc++ libgcc build-base sdl-dev linux-headers file \
 && mkdir /dosbox \
 && cd /build/dosbox-0.74-3 \
 && ./configure --prefix=/usr \
 && make \
 && make install \
 && apk del build-base sdl-dev linux-headers \
 && rm -R /build

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
