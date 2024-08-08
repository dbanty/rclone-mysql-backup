# syntax=docker/dockerfile:1

FROM rclone/rclone:1.67.0 as rclone

FROM mydumper/mydumper:v0.16.6-2

COPY --from=rclone /usr/local/bin/rclone /usr/local/bin/rclone

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MYSQL_HOST=""
ENV MYSQL_USER=""
ENV MYSQL_PASSWORD=""
ENV MYSQL_PORT="3306"
ENV MYSQL_DATABASE=""
ENV R2_ACCESS_KEY_ID=""
ENV R2_SECRET_ACCESS_KEY=""
ENV R2_ENDPOINT=""
ENV R2_BUCKET=""
ENV R2_PATH="mysql-backup"

CMD ["/entrypoint.sh"]
