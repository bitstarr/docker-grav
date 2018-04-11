# docker-grav

Docker files for Grav CMS installation.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Installing

```
$ git clone https://github.com/yosukeo/docker-grav.git
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
| GRAV_VERSION      | 1.4.2             |
| ADMIN_USER        | admin             |
| ADMIN_PASSWORD    | 0Gravity          |
| ADMIN_EMAIL       | admin@example.com |
| ADMIN_PERMISSIONS | b                 |
| ADMIN_FULLNAME    | Sandra Bullock    |
| ADMIN_TITLE       | Administrator     |

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
