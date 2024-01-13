FROM pihole/pihole:latest

COPY gravity.sql.gz /tmp/gravity/
WORKDIR /tmp/gravity
RUN rm /etc/pihole/gravity.db \
    && gunzip gravity.sql.gz \
    && sqlite3 /etc/pihole/gravity.db < /tmp/gravity/gravity.sql \
    && rm -Rf /tmp/gravity
