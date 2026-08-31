FROM hexpm/elixir:1.14.2-erlang-24.3.4.7-alpine-3.16.3 AS build

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

FROM alpine:3.16 AS app

RUN apk add --update --no-cache bash openssl libstdc++

WORKDIR /app

COPY --from=build /app/_build/prod/rel/relayman ./

RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
ENV PATH $PATH:$HOME/bin
