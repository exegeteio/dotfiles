FROM alpine
RUN apk add --no-cache weechat
RUN adduser -D weechat
USER weechat
CMD ["weechat"]
