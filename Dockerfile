FROM alpine:3.12
RUN apk add --no-cache bash curl
COPY README.md /srv/README.md
CMD ["cat", "/srv/README.md"]
