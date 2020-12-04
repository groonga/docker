# Dockerfile for Groonga

Dockerfile for [Groonga](https://groonga.org/) full text search engine.

## Supported tags and respective Dockerfile links

| Groonga | Distribution     | Tags                                 | Path                               |
| ------- | ---------------- | ------------------------------------ | ---------------------------------- |
| 10.0.9  | Debian GNU/Linux | 10.0.9-debian, latest-debian, latest | [debian/Dockerfile][10.0.9-debian] |
| 10.0.9  | Alpine Linux     | 10.0.9-alpine, latest-alpine         | [alpine/Dockerfile][10.0.9-alpine] |
| 10.0.8  | Debian GNU/Linux | 10.0.8-debian                        | [debian/Dockerfile][10.0.8-debian] |
| 10.0.8  | Alpine Linux     | 10.0.8-alpine                        | [alpine/Dockerfile][10.0.8-alpine] |
| 10.0.6  | Debian GNU/Linux | 10.0.6-debian                        | [debian/Dockerfile][10.0.6-debian] |
| 10.0.6  | Alpine Linux     | 10.0.6-alpine                        | [alpine/Dockerfile][10.0.6-alpine] |
| 8.0.3   | Alpine Linux     | 8.0.3                                |                                    |
| 8.0.0   | Alpine Linux     | 8.0.0                                |                                    |
| 7.1.1   | Alpine Linux     | 7.1.1                                |                                    |
| 7.1.0   | Alpine Linux     | 7.1.0                                |                                    |
| 7.0.9   | Alpine Linux     | 7.0.9                                |                                    |
| 7.0.8   | Alpine Linux     | 7.0.8                                |                                    |
| 7.0.7   | Alpine Linux     | 7.0.7                                |                                    |
| 7.0.6   | Alpine Linux     | 7.0.6                                |                                    |
| 7.0.5   | Alpine Linux     | 7.0.5                                |                                    |
| 7.0.4   | Alpine Linux     | 7.0.4                                |                                    |
| 7.0.3   | Alpine Linux     | 7.0.3                                |                                    |
| 7.0.2   | Alpine Linux     | 7.0.2                                |                                    |
| 7.0.1   | Alpine Linux     | 7.0.1                                |                                    |
| 7.0.0   | Alpine Linux     | 7.0.0                                |                                    |

## Usage

There are Debian GNU/Linux based images and Alpine Linux based
images. Debian GNU/Linux images are recommended for normal use. They
start Groonga as an HTTP server by default.. Alpine Linux based images
are for advanced users.

Debian GNU/Linux based images start Groonga as an HTTP server by default:

```console
$ docker run -d --rm --publish=10041:10041 groonga/groonga:latest-debian
```

You can use it via http://127.0.0.1:10041/ .

Alpine Linux based images run `groonga` command without any
argument:

```console
$ docker run -it --rm groonga/groonga:latest-alpine
> status
[[0,1599459609.325239,8.893013000488281e-05],{"alloc_count":320,...}]
> quit
[[0,1599459638.74908,3.409385681152344e-05],true]
$
```

You can run Groonga as an HTTP server with some options:

```console
$ mkdir -p db
$ docker run \
    -d \
    --rm \
    --publish=10041:10041 \
    --volume=$PWD/db:/var/lib/db \
    groonga/groonga:latest-alpine \
    --protocol http \
    -s \
    -n \
    /var/lib/db/db
```

You can use it via http://127.0.0.1:10041/ .

## Customization

You can custom behaviors of Debian GNU/Linux based images by the
following environment variables:

### `GROONGA_ARGS`

You can pass additional command line arguments to `groonga`.

Here is an example to disable cache by passing `--cache-limit=0`
command line argument:

```bash
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --env=GROONGA_ARGS="--cache-limit=0" \
  groonga/groonga:latest-debian
```

### `GROONGA_CACHE_DIR`

The path of the cache directory.

The default is empty. The empty value means that Groonga doesn't use
persistent cache.

See also: [`--cache-base-path`](https://groonga.org/docs/reference/executables/groonga.html#cmdoption-groonga-cache-base-path)

Here is an example to use persistent cache:

```bash
mkdir -p cache
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}/cache:/var/cache/groonga \
  --env=GROONGA_CACHE_DIR="/var/cache/groonga" \
  groonga/groonga:latest-debian
```

### `GROONGA_DB`

The path of the Groonga database.

The default is `/var/lib/groonga/db/db`.

You can use storage in host by just mounting a storage in host to
`/var/lib/groonga/db`:

```bash
mkdir -p db
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}/db:/var/lib/groonga/db \
  groonga/groonga:latest-debian
```

You can also change the database path:

```bash
mkdir -p db
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}:/host \
  --env=GROONGA_DB=/host/db/db \
  groonga/groonga:latest-debian
```

### `GROONGA_INITIALIZE_DIR`

The directory that has data to initialize a newly created Groonga
database.

Note that the default Groonga database specified by `GROONGA_DB`
already exists. If you want to use `GROONGA_INITIALIZE_DIR`, you need
to use change `GROONGA_DB` or attach a volume to
`/var/lib/groonga/db`.

The default is `/var/lib/groonga/initialize`.

The files in `GROONGA_INITIALIZE_DIR` are sorted and passed to Groonga
one by one.

Here is an example files:

```text
.
|-- 0schema
|   |-- 0.grn.zst
|   `-- 1.grn
`-- 1data
    `-- 0-diaries.grn
```

In this case, the following order is used:

  1. `0schema/0.grn.zst`
  2. `0schema/1.grn`
  3. `1data/0-diaries.grn`

You can use compressed files. Here are supported suffixes:

  * `.gz`: Uncompressed by `zcat`.
  * `.zst`: Uncompressed by `zstdcat`.

You can use storage in host by just mounting a storage in host to
`/var/lib/groonga/initialize`. Note that you must change `GROONGA_DB`
(or mount an empty directory as `/var/lib/groonga/db`) to create a new
database:

```bash
mkdir -p db
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}/initialize:/var/lib/groonga/initialize \
  --env=GROONGA_DB=/tmp/db/db \
  groonga/groonga:latest-debian
```

You can also change the data directory:

```bash
mkdir -p db
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}:/host \
  --env=GROONGA_INITIALIZE_DIR=/host/initialize \
  --env=GROONGA_DB=/tmp/db/db \
  groonga/groonga:latest-debian
```

### `GROONGA_LOG_DIR`

The path of the directory to store log files.

The default is `/var/log/groonga`.

You can use storage in host by just mounting a storage in host to
`/var/log/groonga`:

```bash
mkdir -p log
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}/log:/var/log/groonga \
  groonga/groonga:latest-debian
```

You can also change the database path:

```bash
mkdir -p log
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --volume=${PWD}:/host \
  --env=GROONGA_LOG_DIR=/host/log \
  groonga/groonga:latest-debian
```

### `GROONGA_LOG_LEVEL`

The log level.

The default is empty. The empty value means that the Groonga's default
log level (`notice`) is used.

Here is an example to use `debug` log level:

```bash
mkdir -p log
docker run \
  -d \
  --rm \
  --publish=10041:10041 \
  --env=GROONGA_LOG_LEVEL=debug \
  groonga/groonga:latest-debian
```

### `GROONGA_PROTOCOL`

The protocol that uses Groonga server.

The default is `http`. You can use `http`, `gqtp` or `memcached`.

Here is an example to use `gqtp` protocol:

```bash
docker run \
  -d \
  --rm \
  --publish=10043:10043 \
  --env=GROONGA_PROTOCOL=10043 \
  groonga/groonga:latest-debian
```

[10.0.9-debian]: https://github.com/ggroonga/docker/tree/10.0.9-debian/Dockerfile
[10.0.9-alpine]: https://github.com/ggroonga/docker/tree/10.0.9-alpine/Dockerfile
[10.0.8-debian]: https://github.com/ggroonga/docker/tree/10.0.8-debian/Dockerfile
[10.0.8-alpine]: https://github.com/ggroonga/docker/tree/10.0.8-alpine/Dockerfile
[10.0.6-debian]: https://github.com/ggroonga/docker/tree/10.0.6-debian/Dockerfile
[10.0.6-alpine]: https://github.com/ggroonga/docker/tree/10.0.6-alpine/Dockerfile
