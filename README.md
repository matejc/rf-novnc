# Robot Framework NoVNC Docker development environment

## Features

### Multi-library support

Browser library and Selenium library images


### No specific web browser requirements on host

The browsers are in the image already.
Browser: All the browsers that come with the `robotframework-browser` Python library.
Selenium: Firefox and Chrome.


### No web driver requirements

For Selenium, correct web drivers are already included.


### Change web browser at run-time

Since the browsers are already present in the image, they all can be required at run-time.


### Faster development (hot-reload)

When running in watch mode, it will rerun robot command for each save of any file inside mounted directory


### Execution progress in any web browser

Under the hood it is running X11 server and VNC setup with NoVNC to translate the action inside the container to your favorite browser through HTTP as a web site


## Requirements

- Docker or Podman


## Usage (Browser)

### Build

```shell
$ docker build -f Dockerfile.Browser -t rf-novnc:Browser
```


### Run once

It's meant to run in CI/CD or in environment where you want to run robot once and optionally look at execution if the tests run longer time.

```shell
$ docker run -ti --rm -p 6080:6080 \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```

And then check execution of Robot Framework tests in your favorite browser at address `http://localhost:6080`


### Run and watch for changes

It's meant for development or for workshops where you want to focus on Robot Framework code and not on setup of the environment.

```shell
$ docker run -ti --rm -p 6080:6080 -e ROBOT_WATCH=1 \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```

And then check execution of Robot Framework tests in your favorite browser at address `http://localhost:6080`


### Environment Variables

#### ROBOT_WATCH

Set this variable to non-empty for process to watch for changes in files in the volume. Container will never exit so you have to manually stop it when you are done with Ctrl+C or using `docker stop`.


#### ROBOT_ARGS

Provide CLI arguments to the robot command. If you want to include tests with specific tags, in this example use `--include smoke` to run only tests with tag `smoke`.


### Volumes

#### Tests

Container needs to be somehow aware of the tests that you would like to run, so for Robot Framework project files you need to mount the directory to `/home/pwuser/source`, it is expected that directory has a sub-directory called `tests`.


#### Logs (debug only)

Since the container will run several processes for its function, like X server, VNC, NoVNC/websockify and window manager the logs for those will go to `/home/pwuser/logs` directory.


### Ports


## Pre-built docker images

https://hub.docker.com/r/matejc/rf-novnc/tags
