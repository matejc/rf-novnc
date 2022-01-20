# Robot Framework NoVNC Docker development environment

A project that makes debugging easier by having Robot Framework setup for Playwright and Selenium with included web browsers as a docker image.
The setup also uses NoVNC accessible as web page where you can see actual execution, so that the Robot Framework does not rely on web browsers on host machine.

<img src="/images/in_action.png" width="100%">


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


## Usage

Next examples are for Browser library, but if you need Selenium, just use corresponding Docker file and Docker tag.


### Build

```shell
$ docker build -f Dockerfile.Browser -t rf-novnc:Browser
```


### Pre-built Docker images

Pre-build Docker images also exist on Docker Hub.

https://hub.docker.com/r/matejc/rf-novnc/tags


### Run once

It's meant to run in CI/CD or in environment where you want to run robot once and optionally look at execution if the tests run longer time.

```shell
$ docker run -ti --rm -p 6080:6080 -p 10081:10081 \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```

And then check execution of Robot Framework tests in your favorite browser at address `http://localhost:6080`


### Run and watch for changes

It's meant for development or for workshops where you want to focus on Robot Framework code and not on setup of the environment.

You can also click the Run button in the UI at `http://localhost:6080`

```shell
$ docker run -ti --rm -p 6080:6080 -p 10081:10081 -e ROBOT_RUN_MODE=watch \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```

And then check execution of Robot Framework tests in your favorite browser at address `http://localhost:6080`


### Run on button only

It's meant for when you need to run on demand by clicking on Run button at `http://localhost:6080`.

```shell
$ docker run -ti --rm -p 6080:6080 -p 10081:10081 -e ROBOT_RUN_MODE=button \
  -v ./examples/Browser:/home/pwuser/source:ro rf-novnc:Browser
```

And then check execution of Robot Framework tests in your favorite browser at address `http://localhost:6080`


### Environment Variables

#### ROBOT_RUN_MODE

If you set the variable to `button` then you can execute the robot only on demand by clicking Run button from UI.

Set this variable to `watch` for process to watch for changes in files in the volume. Container will never exit so you have to manually stop it when you are done with Ctrl+C or using `docker stop` or using `Terminate` button from UI. Keep in mind that watch mode still permits to run robot by clicking Run button.

Else if you do not set the variable or set it to invalid string, then the robot will run immediately and exit after its run.


#### ROBOT_ARGS

Provide CLI arguments to the robot command. If you want to include tests with specific tags. For example use `--include smoke` to run only tests with tag `smoke`.


### Volumes

#### Tests

Container needs to be somehow aware of the tests that you would like to run, so for Robot Framework project files you need to mount the directory to `/home/pwuser/source`, it is expected that directory has a sub-directory called `tests`.


#### Output

For accessing output files of robot run (log and result html/xml files), mount a volume to the host directory at `/usr/share/novnc/output` in the container.


#### Logs (debug only)

Since the container will run several processes for its function, like X server, VNC, NoVNC/websockify and window manager the logs for those will go to `/home/pwuser/logs` directory.


### Ports

NoVNC/websockify is listening on 0.0.0.0:6080 inside of container, so make sure to map that port out if you plan to preview the execution.

For actions like `Run` and `Terminate` button functionality, port `10081` is also needed to be published.


## Extend Docker image

In practice there is sometimes a need to extend with ex. Robot Framework modules.
Here is the example of how to do just that:

```docker
FROM docker.io/matejc/rf-novnc:Browser

USER pwuser

ADD ./requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --user -r /tmp/requirements.txt

USER root  # make sure that you end with seting the user back to root
```


## Known Issues

- When running from `podman`, you might need to add the `--security-opt label=disable` to overcome `Permission Denied` issue when robot is trying to read from volume.


## ToDo

- Rerun robot on save (kill the previous run)
