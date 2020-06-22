FROM elixir:1.10-alpine AS build

ENV MIX_ENV=prod

RUN apk add --update git build-base

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix deps.get
RUN mix deps.compile

COPY priv priv
COPY lib lib

RUN mix compile

COPY rel rel

RUN mix release

FROM alpine AS app

RUN apk add --update bash openssl

WORKDIR /app

COPY --from=build /app/_build/prod/rel/relayman ./

RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
ENV PATH $PATH:$HOME/bin