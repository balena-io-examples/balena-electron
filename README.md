# Balena Electron Example

This is a very simple, barebones example of how to get an electron app running on balena. It is split out into two parts.

- One piece is your application (this repo) that installs all dependencies for Electron to be able to run.
- The second piece is the [xserver](https://github.com/balenablocks/xserver) block, which starts up an X11 server that your application will use to display on. 

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-examples/balena-electron-example)

## Example `docker-compose.yml`

```
version: '2.1'
volumes:
    # we create a shared volume so that the xserver can mount its socket file, and our application container will be able to use it to display
    data:
    xserver:
services:
  balena-electron-example:
    build: balena-io-examples/balena-electron
    restart: always
    network_mode: host
    ports:
      - 8080:8080
    volumes:
      - 'data:/data/'
      - 'xserver:/tmp/.X11-unix'
    shm_size: '2gb'
  xserver:
    image: balenablocks/xserver
    restart: always
    privileged: true
    volumes:
      - 'xserver:/tmp/.X11-unix'
```
