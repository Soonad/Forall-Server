FROM elixir:1.9.4-alpine

RUN apk add -U \
    --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    nodejs git

RUN mix local.hex --force && \
    mix local.rebar --force