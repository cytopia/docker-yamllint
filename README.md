# Docker image for `yamllint`

[![Build Status](https://travis-ci.com/cytopia/docker-yamllint.svg?branch=master)](https://travis-ci.com/cytopia/docker-yamllint)
[![Tag](https://img.shields.io/github/tag/cytopia/docker-yamllint.svg)](https://github.com/cytopia/docker-yamllint/releases)
[![](https://images.microbadger.com/badges/version/cytopia/yamllint:latest.svg)](https://microbadger.com/images/cytopia/yamllint:latest "yamllint")
[![](https://images.microbadger.com/badges/image/cytopia/yamllint:latest.svg)](https://microbadger.com/images/cytopia/yamllint:latest "yamllint")
[![](https://img.shields.io/badge/github-cytopia%2Fdocker--yamllint-red.svg)](https://github.com/cytopia/docker-yamllint "github.com/cytopia/docker-yamllint")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

> #### All awesome CI images
>
> [ansible](https://github.com/cytopia/docker-ansible) |
> [ansible-lint](https://github.com/cytopia/docker-ansible-lint) |
> [awesome-ci](https://github.com/cytopia/awesome-ci) |
> [eslint](https://github.com/cytopia/docker-eslint) |
> [file-lint](https://github.com/cytopia/docker-file-lint) |
> [jsonlint](https://github.com/cytopia/docker-jsonlint) |
> [pycodestyle](https://github.com/cytopia/docker-pycodestyle) |
> [terraform-docs](https://github.com/cytopia/docker-terraform-docs) |
> [yamllint](https://github.com/cytopia/docker-yamllint)


View **[Dockerfile](https://github.com/cytopia/docker-yamllint/blob/master/Dockerfile)** on GitHub.

[![Docker hub](http://dockeri.co/image/cytopia/yamllint)](https://hub.docker.com/r/cytopia/yamllint)


Tiny Alpine-based dockerized version of [yamllint](https://github.com/adrienverge/yamllint)<sup>[1]</sup>.
The image is built nightly against the latest stable version of `yamllint` and pushed to Dockerhub.

<sup>[1] Official project: https://github.com/adrienverge/yamllint</sup>


## Available Docker image versions

| Docker tag | Build from |
|------------|------------|
| `latest`   | Current stable yamllint version |


## Docker mounts

The working directory inside the Docker container is **`/data/`** and should be mounted locally to
the root of your project where your `.yamllint` file is located.


## Usage

```bash
docker run --rm -v $(pwd):/data cytopia/yamllint .
```


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
