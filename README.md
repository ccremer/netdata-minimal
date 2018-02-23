# netdata-minimal
Minimal netdata installation with all plugins disabled by default. This
image is intended as a base image for netdata custom plugins running as
a microservice with a backend or stream enabled (which is disabled by default, see
the overriding section).

This image is being pushed to Docker Hub whenever
[firehol/netdata](https://hub.docker.com/r/firehol/netdata/) is updated.

**Note**: The web UI and health checks of netdata are disabled by default.
 Even if enabled (see env vars) then it does not show any charts,
you will only see the footer and menu.

### PLEASE HOLD ON BEFORE USING NETDATA USER

Until https://github.com/firehol/netdata/pull/3463 is merged, only user root is supported.

## How to get started

1. Declare `FROM braindoctor/netdata-minimal` in your Dockerfile
2. Override the config (see below)
3. Enable the web service for debugging purposes
4. Declare `USER netdata:netdata` at the end of your Dockerfile (recommended)

## What's in the box

* Alpine edge
* Full netdata installation (latest git clone & compile), but the default
plugins are disabled using config options in `/etc/netdata/netdata.conf`
* Python, and some pkgs: py-mysqldb, py-psycopg2, netcat-openbsd
* Nodejs (without npm)
* Crudini (for easy ini editing)
* jq (for easy json editing)
* merge-yaml-cli (for easy yaml editing)
* bash (just 1 additional MB, but makes scripting so much easier)

## Environment variables

Some basic settings can be applied without having to override them in files.

Key | Default value | Accepted values | Description
--- | ---           | ---             | ---
`N_ENABLE_WEB`             | `no` | `yes` or `no`  | Set it to `yes` to enable the web UI.
`N_ENABLE_HEALTH`          | `no` | `yes` or `no`  | Set it to `yes` to enable health.
`N_ENABLE_PYTHON_D`        | `no` | `yes` or `no`  | Set it to `yes` to enable python plugins.
`N_ENABLE_NODE_D`          | `no` | `yes` or `no`  | Set it to `yes` to enable nodejs plugins.
`N_STREAM_DESTINATION`     | (unset) | DNS or IP   | The netdata streaming master. Requires `N_STREAM_API_KEY`.
`N_STREAM_API_KEY`         | (unset) | uuid        | The API key for streaming.
`N_STREAM_MASTER_MEMORY`   | (unset) | `save`, `ram`, `none` or `map` | The memory mode of the netdata master (enabled by settings this). Requires `N_STREAM_API_KEY`.
`N_HOSTNAME`               | (unset) | string      | The hostname for netdata (affects streaming). Default is container hostname.

## Overriding netdata configuration

Overriding netdata configuration is relatively easy. In your Dockerfile,
either:
- Replace `/etc/netdata/overrides/netdata.ini` with your file. Make sure user
`netdata` can read the file.
- Mount `/etc/netdata/overrides` from outside (permissions!).
- Append section and key/value pairs using echo in your `RUN`
instructions, e.g:
```
FROM braindoctor/netdata-minimal
RUN \
    echo "[plugins]" >> /etc/netdata/overrides/netdata.ini
    echo "python.d = yes" >> /etc/netdata/overrides/netdata.ini
```

Whichever method you prefer, do NOT provide leading whitespace in your
ini file, or else parsing and merging will fail!

As an alternative, you can 

## Installing/Enabling custom plugins

In your Dockerfile, install them as you would on a normal system:
1. Make sure that the dependencies are installed.
2. Install configuration file(s) for netdata.
3. Ensure that user netdata can read and execute the plugin and config
file(s) by setting the proper permissions.
4. Build & Test.

## Tags

* `latest`: Most up-to-date netdata version, based on Alpine.

## Netdata user

For `latest`, this image has been built so that user `netdata (101:101)`
can run netdata. However, in this Dockerfile it is still root, assuming
that you will install additional stuff as root. It is recommended that you
add `USER netdata:netdata` somewhere in your derived Dockerfile.
