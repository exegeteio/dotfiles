FROM alpine
RUN apk add --no-cache lynx
COPY ./build/docker/lynx /etc
ENTRYPOINT ["lynx"]
