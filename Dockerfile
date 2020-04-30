FROM golang:alpine as gobuild

RUN apk update; \
    apk add git gcc build-base; \
    go get -v github.com/cloudflare/cloudflared/cmd/cloudflared

WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN GOARCH=amd64 GOARM=6 go build ./

FROM multiarch/alpine:amd64-edge

LABEL maintainer="Daevien"

ENV UPSTREAM1 https://1.1.1.1/.well-known/dns-query
ENV UPSTREAM2 https://1.0.0.1/.well-known/dns-query
ENV UPSTREAM3 https://dns.google/dns-query
ENV PORT 5054

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' > /etc/apk/repositories ; \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories; \
    adduser -S cloudflared; \
    apk add --no-cache ca-certificates bind-tools libcap; \
    rm -rf /var/cache/apk/*;

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

RUN setcap CAP_NET_BIND_SERVICE+eip /usr/local/bin/cloudflared

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nslookup -po=${PORT} cloudflare.com 127.0.0.1 || exit 1

USER cloudflared

CMD ["/bin/sh", "-c", "/usr/local/bin/cloudflared proxy-dns --address 0.0.0.0 --port ${PORT} --upstream ${UPSTREAM3} --metrics 0.0.0.0:5055"]
