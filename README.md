# dos-pascal-docker

Docker to compile pascal file in dos and build website to run created exe file.
I used in two my old projects: [Deska](https://gitlab.com/adam-zielonka-pro/deska) and [Saper](https://gitlab.com/adam-zielonka-pro/saper).

## How to use

You have several options to use this docker. In this example in main project directory exist folder `src` and inside this folder exist file called `DESKA.PAS`.

### docker cli

```shell
docker run --rm -it -w="/project" -v $(pwd):/project \
  ghcr.io/adam-zielonka/dos-pascal-docker:main src/DESKA.PAS
```

You can add `--watch` to auto-compile after file changes.

### docker-compose.yml

```yml
version: '3.7'
services:

  app:
    image: ghcr.io/adam-zielonka/dos-pascal-docker:main
    working_dir: /project
    volumes:
      - ./:/project
    command: ['src/DESKA.PAS']
```

### GitHub Action

```yml
name: CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Setup Pages
        uses: actions/configure-pages@v2
      - name: Build
        uses: adam-zielonka/dos-pascal-docker@e599d394c5fbac94e270949e009b72a290600cb9
        with:
          path: src/DESKA.PAS
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: ./build

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v1

```

### .gitlab-ci.yml

```yml
pages:
  image: 
    name: registry.gitlab.com/adam-zielonka-pro/dos-pascal-docker
    # name: ghcr.io/adam-zielonka/dos-pascal-docker:main
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
