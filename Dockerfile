FROM mysql:5.7

LABEL maintainer="OSSHelp Team, https://oss.help"
LABEL description="One shot container which creates dbs, users and extensions"

COPY entrypoint.sh /usr/local/bin/
USER nobody

ENV MYSQL_HOST=mysql \
    MYSQL_PORT=3306 \
    MYSQL_USER=root \
    MYSQL_PASSWORD=password \
    MYSQL_TIMEOUT=60 \
    MYSQL_CHARACTER=utf8 \
    MYSQL_COLLATE=utf8_general_ci

ENTRYPOINT ["entrypoint.sh"]
