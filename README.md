# docker-grav

Docker files for Grav CMS installation.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Installing

```
$ git clone https://github.com/bitstarr/docker-grav
$ cd docker-grav
$ docker-compose build
```

You may take a few minutes for executing `docker-compose build`.

### Create and start container

```
$ docker-compose up -d
```

### Login container

```
$ docker exec -it --env COLUMNS=`tput cols` --env LINES=`tput lines` grav bash
```

Unless you add `--env` options, your console layout maybe broken.

## Settings

You can change settings by editing `docker-compose.yml`. All arguments are shown in the table below.

| args              | Default Value     |
| ----------------- | ----------------- |
| GRAV_VERSION      | latest            |
| ADMIN_USER        | dev               |
| ADMIN_PASSWORD    | Developer1       |
| ADMIN_EMAIL       | dev@dev.dev      |
| ADMIN_PERMISSIONS | b                 |
| ADMIN_FULLNAME    | Hagbard Celine    |
| ADMIN_TITLE       | God               |

## Usage

After first startup there will be a folder ``app`` which contains the grav root directory.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
