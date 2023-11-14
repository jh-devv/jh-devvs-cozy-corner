FROM debian:latest as zola-base
RUN apt-get update && apt-get install -y openssl wget
RUN wget -c https://github.com/getzola/zola/releases/download/v0.10.0/zola-v0.10.0-x86_64-unknown-linux-gnu.tar.gz -O - | tar -xz
RUN mv zola /usr/bin
RUN mkdir /site
WORKDIR /site

FROM zola-base as builder
COPY . /site
RUN zola build

FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=builder /site/public/ /usr/share/nginx/html/
EXPOSE 80