FROM golang:1.23.3@sha256:b2ca38170893394183f940a7f988bf15c4112a4ddb73214941fe4d08a09f9329 AS builder

WORKDIR /tmp/hugo
COPY . .

# Intall Hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.138.0/hugo_extended_0.138.0_linux-amd64.deb -O hugo.deb -q && \
    apt install ./hugo.deb

# Install nmp and dependencies
RUN apt update && apt install npm -y -q && \
    npm install package.json

RUN hugo --gc --minify



FROM nginx:1.27.2@sha256:bc5eac5eafc581aeda3008b4b1f07ebba230de2f27d47767129a6a905c84f470
ARG BASE_URL="docs.ctfer.io"
ENV NGINX_HOST=$BASE_URL

COPY --from=builder /tmp/hugo/public /usr/share/nginx/html
