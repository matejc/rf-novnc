# Robot Framework NoVNC Docker development environment


## Usage (Browser)

### Build

```shell
$ docker build -f Dockerfile.Browser -t rf-novnc:Browser
```


### Run once

```shell
$ docker run -ti --rm -p 6080:6080 \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```


### Run and watch for changes

```shell
$ docker run -ti --rm -p 6080:6080 -e ROBOT_WATCH=1 \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```


## Pre-built docker images

https://hub.docker.com/r/matejc/rf-novnc/tags
