FROM alpine
RUN apk add --no-cache lynx
COPY ./docker/lynx /etc
ENTRYPOINT ["lynx"]
