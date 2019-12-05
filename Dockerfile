FROM elixir:1.9.4-alpine

WORKDIR /root

ENV MIX_ENV prod

RUN mix local.hex --force && mix local.rebar --force

COPY mix.lock .
COPY mix.exs .

RUN mix deps.get

COPY . .

RUN mix release

FROM alpine:latest

WORKDIR /root

ENV MIX_ENV prod
ENV PATH $PATH:/root/bin

COPY --from=0 /root/_build/prod/rel/relayman_web .