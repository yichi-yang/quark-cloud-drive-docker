# quark-cloud-drive-docker

A containerized Quark Cloud Drive client, based on [docker-baseimage-kasmvnc](https://github.com/linuxserver/docker-baseimage-kasmvnc/tree/master).
Uses the windows version of Quark client and Wine.

### Build

``` bash
docker build . -t quark-cloud-drive
```

### Run

``` bash
docker run --rm -it -p 3000:3000 quark-cloud-drive
```

Then access the client on http://localhost:3000. You can set UID/GID with `-e PUID=1000 -e PGID=1000` if needed.
