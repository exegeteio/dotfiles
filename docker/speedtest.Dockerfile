FROM alpine

RUN apk add --no-cache speedtest-cli
ENTRYPOINT ["speedtest"]

