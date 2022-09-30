# dos-pascal-docker

Docker to compile pascal file in dos and build website to run created exe file.
I used in two my old projects: [Deska](https://gitlab.com/adam-zielonka-pro/deska) and [Saper](https://gitlab.com/adam-zielonka-pro/saper).

## How to use

You have several options to use this docker. In this example in main project directory exist folder `src` and inside this folder exist file called `DESKA.PAS`.

### docker cli

```bash
$ docker run --rm -it -w="/project" -v $(pwd):/project \
  registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker:latest src/DESKA.PAS
```

You can add `--watch` to auto-compile after file changes.

### docker-compose.yml

```yml
version: '3.7'
services:

  app:
    image: registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker
    working_dir: /project
    volumes:
      - ./:/project
    command: ['src/DESKA.PAS']
```

### .gitlab-ci.yml

```yml
pages:
  image: 
    name: registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker
    entrypoint: [""]
  script:
    - docker-entrypoint.sh src/DESKA.PAS
    - mv build public
  artifacts:
    expire_in: 1 week
    paths:
    - public
  only:
    - master
```

## Notice

To build this docker I used:

- [DOSBox](https://www.dosbox.com/)
- [Turbo Pascal (With DOSBox)](https://sourceforge.net/projects/turbopascal-wdb/)
- [js-dos](https://js-dos.com/)
- [tudorh/dosbox](https://hub.docker.com/r/tudorh/dosbox)

## License

MIT
