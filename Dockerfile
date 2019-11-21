# ---------------------------------------------------------
# Build Release
# ---------------------------------------------------------
FROM elixir:1.9.4-alpine as build

ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force

RUN apk add -U --no-cache git

RUN mkdir -p /app
WORKDIR /app

COPY mix.exs .
COPY mix.lock .

RUN mix deps.get
RUN mix deps.compile

COPY config ./config
COPY lib ./lib
COPY priv ./priv

RUN mix phx.digest
RUN mix release

# ---------------------------------------------------------
# Run Release
# ---------------------------------------------------------
FROM node:12-alpine
LABEL maintainer="Bernardo Amorim"

RUN apk add -U --no-cache bash openssl

RUN addgroup -g 999 forall && \
    adduser -S -h /app -G forall -u 999 forall

COPY --from=build --chown=forall:forall /app/_build/prod/rel/forall /app/.
COPY --chown=forall:forall file_checker /file_checker
ENV FILE_CHECKER_PATH=/file_checker

USER forall

CMD /app/bin/forall start