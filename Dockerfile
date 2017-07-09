FROM alpine:edge
ADD will.jordan@gmail.com-56ba6562.rsa.pub /etc/apk/keys/
RUN apk add \
  --no-cache \
  --update \
  --repository http://dl-4.alpinelinux.org/alpine/edge/testing \
  --repository https://s3.amazonaws.com/wjordan-apk \
  node-sharp
