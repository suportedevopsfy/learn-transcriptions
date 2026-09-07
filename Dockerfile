FROM alpine:3.12
RUN apk add --no-cache bash curl && echo "poc golden path" > /hello.txt
CMD ["cat", "/hello.txt"]
