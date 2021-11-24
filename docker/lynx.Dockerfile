FROM alpine
RUN apk add --no-cache lynx
COPY ./lynx /etc
ENTRYPOINT ["lynx"]
