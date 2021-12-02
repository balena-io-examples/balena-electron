# Balena Electron Example

This is a very simple, barebones example of how to get an electron app running on balena. It is split out into two parts.

- One piece is your application (this repo) that installs all dependencies for Electron to be able to run.
  - This example app has an `express` server, and starts a window in kiosk mode.
- The second piece is the [xserver](https://github.com/balenablocks/xserver) block, which starts up an X11 server that your application will use to display on.
  - You can see all the environment variables to configure xserver [here](https://github.com/balenablocks/xserver#environment-variables)

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-examples/balena-electron-example)

## Example `docker-compose.yml`

```
version: '2.1'
volumes:
    # we create a shared volume so that the xserver can mount its socket file, and our application container will be able to use it to display
    xserver-volume:
services:
  xserver:
    image: balenablocks/xserver
    restart: always
    privileged: true
    volumes:
      # when we start, a UNIX socket is mounted in this directory, for communication to the X server
      - 'xserver-volume:/tmp/.X11-unix'
  balena-electron:
    build: .
    restart: always
    network_mode: host
    ports:
      - 8080:8080
    volumes:
      # We will have access to the UNIX socket shared by xserver after it has started up.
      - 'xserver-volume:/tmp/.X11-unix'
    environment:
      # We need to specify which display we want to use for the X server. :0 is the first display that we have plugged in. This because there is no default display specified.
      - DISPLAY=:0
```
