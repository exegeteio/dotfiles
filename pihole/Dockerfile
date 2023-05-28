FROM pihole/pihole:latest

COPY gravity.db.gz /etc/pihole/
RUN rm /etc/pihole/gravity.db && gunzip /etc/pihole/gravity.db.gz
