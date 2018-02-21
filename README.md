# netdata-minimal
Minimal netdata installation with all plugins disabled by default. This
image is intended as a base image for netdata custom plugins running as
a microservice with a backend or stream enabled (which is disabled by default, see
the overriding section).

This image is being pushed to Docker Hub whenever
[firehol/netdata](https://hub.docker.com/r/firehol/netdata/) is updated.

**Note**: The web UI of netdata is disabled by default. You can enable it by
setting env var `ENABLE_WEB=true`. Even then it does not show any charts,
you will only see the footer and menu.

## What's in the box

* `1.9`: Debian `stable-slim`
* `latest`: Alpine `edge`
* Full netdata installation (latest git clone & compile), but the default
plugins are disabled using config options in `/etc/netdata/netdata.conf`
* Python 2.7 (python2-minimal)
* On `latest`: nodejs
* Crudini (for easy ini editing)
* jq (for easy json editing)

## Overriding netdata configuration

Overriding netdata configuration is relatively easy. In your Dockerfile,
either:
- Replace `/etc/netdata/overrides/netdata.ini` with your file. Make sure user
`netdata` can read the file.
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

As an alternative, you can mount `/etc/netdata/overrides` from
outside (permissions!), just make sure you have the changes from the
original files before "overmounting" them.

## Installing/Enabling custom plugins

In your Dockerfile, install them as you would on a normal system:
1. Make sure that the dependencies are installed.
2. Install configuration file(s) for netdata.
3. Ensure that user netdata can read and execute the plugin and config
file(s) by setting the proper permissions.
4. Build & Test.

## Tags

* `latest`: Most up-to-date netdata version, based on Alpine.
* `1.9`: Release 1.9.x of netdata.