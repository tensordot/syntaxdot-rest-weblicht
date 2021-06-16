## Introduction

This repository can be used to build SyntaxDot REST server Docker images for
WebLicht. The server pipelines are defined in `weblicht-pipelines.nix`.

## Building a Docker image

The Docker images tarball can be built using the following Nix command. A
symlink `result` will be created, which points to the Docker image:

``` shell
$ nix-build \
  https://github.com/tensordot/syntaxdot-rest-weblicht/archive/main.tar.gz \
  -A packages.x86_64-linux.dockerImage
$ realpath result
/nix/store/a1567d8spndh39njdkgh5yrjirz8ybw0-syntaxdot-rest-server.tar.gz
$ docker load < result
```

It is also possible to stream the layers directly into `docker load`, without
creating the (large) intermediate tarball:

``` shell
$ $(nix-build \
  https://github.com/tensordot/syntaxdot-rest-weblicht/archive/main.tar.gz \
  -A packages.x86_64-linux.streamDockerImage) | docker load
```
