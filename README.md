# Cloudflared

Forked from [https://github.com/visibilityspots/dockerfile-cloudflared]. A docker container which runs the [cloudflared](https://developers.cloudflare.com/1.1.1.1/dns-over-https/cloudflared-proxy/) proxy-dns at port 5054 based on alpine with some parameters to enable DNS over HTTPS proxy for [pi-hole](https://pi-hole.net/) based on tutorials from [Oliver Hough](https://oliverhough.cloud/blog/configure-pihole-with-dns-over-https/) and [Scott Helme](https://scotthelme.co.uk/securing-dns-across-all-of-my-devices-with-pihole-dns-over-https-1-1-1-1/). Modified by Daevien to use both cloudflare and google backends. Also adjusts metrics server to use 0.0.0.0:5055 for future use.

## run

```docker run --name cloudflared --rm --net host daevien/cloudflared```

### custom upstream DNS

```docker run --name cloudflared --rm --net host -e DNS1=#.#.#.# -e DNS2=#.#.#.# daevien/cloudflared```

### custom port

``` docker run --name cloudflared --rm --net host -e PORT=5053 daevien/cloudflared```
