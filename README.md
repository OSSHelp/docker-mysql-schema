# mysql-schema

[![Build Status](https://drone.osshelp.ru/api/badges/docker/mysql-schema/status.svg)](https://drone.osshelp.ru/docker/mysql-schema)

## Description

One-shot container for init MySQL users and databases.

## Deploy examples

### Docker Compose

``` yaml
  mysql-schema:
    image: osshelp/mysql-schema:stable
    restart: "no"
    environment:
      MYSQL_PASSWORD: $MYSQL_ROOT_PASSWORD
      MYSQL_DBS: "DB1_NAME:$USER1_PASSWORD, DB2_NAME:$USER2_PASSWORD"
      MYSQL_NETDATA_USER_PASSWORD: $MYSQL_NETDATA_USER_PASSWORD
    networks:
      - net
```

### Docker swarm

``` yaml
  mysql-schema:
    image: osshelp/mysql-schema:stable
    deploy:
      restart_policy:
        condition: none
    environment:
      MYSQL_PASSWORD: $MYSQL_ROOT_PASSWORD
      MYSQL_DBS: "DB1_NAME:$USER1_PASSWORD, DB2_NAME:$USER2_PASSWORD"
      MYSQL_NETDATA_USER_PASSWORD: $MYSQL_NETDATA_USER_PASSWORD
    networks:
      - net
```

## Parameters

Setting|Default|Description
---|---|---
`MYSQL_HOST`|`mysql`|MySQL host
`MYSQL_PORT`|`3306`|MySQL port
`MYSQL_USER`|`root`|MySQL superuser
`MYSQL_PASSWORD`|`password`|MySQL superuser password
`MYSQL_TIMEOUT`|`60`|Timeout in seconds for wating MySQL host connection
`MYSQL_DBS`|-|List of DB_NAME:PASSWORD (delimiter: space or comma. USERNAME is equal to DBNAME)
`MYSQL_NETDATA_USER_PASSWORD`|-|MySQL the netdata user password
`MYSQL_CHARACTER`|`utf8`|MySQL DBS CHARACTER
`MYSQL_COLLATE`|`utf8_general_ci`|MySQL DBS COLLATE

### Internal usage

For internal purposes and OSSHelp customers we have an alternative image url:

``` yaml
  image: oss.help/pub/mysql-schema:stable
```

There is no difference between the DockerHub image and the oss.help/pub image.

## Links

- [MySQL Documentation](https://dev.mysql.com/doc/)

## TODO

- Add fixture dumps support (restore from dump if DB doesn't exits)
