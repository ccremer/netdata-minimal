# netdata-minimal
Minimal netdata installation with all plugins disabled by default. This
image is intended as a base image for netdata custom plugins running as
a microservice with a backend or stream enabled (which is disabled by default, see below).

This image is being weekly built and pushed to Docker Hub.

**Note**: The web UI and health checks of netdata are disabled by default.
 Even if enabled (see env vars) then it does not show any charts,
you will only see the footer and menu.

## How to get started

1. Declare `FROM braindoctor/netdata-minimal` in your Dockerfile
2. Override the config (see below)
3. Enable the web service for debugging purposes

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
`N_ENABLE_WEB`             | `no` | `yes` or `no`    | Set it to `yes` to enable the web UI.
`N_DISABLE_WEB_LOG`        | `no` | `yes` or `no`    | Set it to `yes` to disable the web access log.
`N_ENABLE_HEALTH`          | `no` | `yes` or `no`    | Set it to `yes` to enable health.
`N_ENABLE_PYTHON_D`        | `no` | `yes` or `no`    | Set it to `yes` to enable python plugins.
`N_ENABLE_NODE_D`          | `no` | `yes` or `no`    | Set it to `yes` to enable nodejs plugins.
`N_STREAM_DESTINATION`     | (unset) | DNS or IP     | The netdata streaming master. Requires `N_STREAM_API_KEY`.
`N_STREAM_API_KEY`         | (unset) | uuid          | The API key for streaming.
`N_STREAM_MASTER_MEMORY`   | (unset) | `save`, `ram`, `none` or `map` | The memory mode of the netdata slaves (enables master). Requires `N_STREAM_API_KEY`.
`N_STREAM_MASTER_HEALTH`   | `auto` | `yes`, `auto`, or `no` | Whether health checks are enabled for slaves. `auto` means `yes, if connected`.
`N_HOSTNAME`               | (unset) | string        | The hostname for netdata (affects streaming). Default is container hostname.
`N_MEMORY_MODE`            | `save` | `save`, `ram`, `none` or `map` | The memory mode of this node.

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

## Installing/Enabling custom plugins

In your Dockerfile, install them as you would on a normal system:
1. Make sure that the dependencies are installed.
2. Install configuration file(s) for netdata.
3. Ensure that user `netdata` can read and execute the plugin and config
file(s) by setting the proper permissions.
4. Build & Test.

## Installing custom scripts

Provide any shell scripts ending with `.sh` in `/etc/netdata/pre-start.d` or `/etc/netdata/post-start.d`.
Pre-start scripts are executed before merging/overwriting files from `/etc/netdata/overrides` in alphabetical order.
Post-start scripts after merging but before starting netdata. The scripts will be called with `bash`.

## Tags

All tags are based on Multi-Arch Alpine

* `latest`, equals `amd64`
* `armhf`
* `i386`
* `aarch64`

## Netdata user

The official firehol/netdata base image has been built so that user `netdata` can run netdata. Initially, the container 
will start as root, but then switches user. 
