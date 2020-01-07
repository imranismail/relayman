# Relayman

Relayman is a minimal CloudEvents server that can be used for producing events via HTTP and consume them by subscribing to an event source using a WebSocket connection.

The idea was conceptualized when I was dealing with clients that polls servers that are not built to provide real-time updates to client.

Relayman adheres to the CloudEvents Specification v1.0. There will be little to no activity on this repo as it's considered feature complete.

There will be security patches and update if there are any changes to the specification made by the working group.

## Goals
- Stateless
- Zero opinions

## Non Goals
- Replayability
- Endpoint security (your operations team should make the `/events` endpoint an internal API to prevent malicious actors from producing event)
- Socket authentication (this was built primarily to tackle UI updates, so don't pass any sensitive data other than pointers)


## API Docs

```elixir
params do
  requires :specversion, :string, default: "1.0"
  requires :id, :string
  requires :source, :string
  requires :type, :string
  optional :datacontenttype, :string
  optional :dataschema, :string
  optional :subject, :string
  optional :time, :string
  optional :data, :map
end
```

## Usage

Start the server

```
docker run -it -b 4000:4000 imranismail/relayman relayman start
```

### Producing Event

```sh
# create a cloudevent
# note: source and type denotes where the event will be published to
curl -X POST \
  http://localhost:4000/events \
  -H 'Content-Type: application/json' \
  -d '{"id":"uuid","source":"/outlets/1/orders","type":"created","subject":"1","data":{"id": "1"}}'
```

### Subscribing to an Event source

```js
import { Socket } from "phoenix";
# setup a socket instance
let socket = new Socket("ws://localhost:4000/socket");
# setup a channel
let channel = socket.channel("source:/outlets/1/orders");
# connect to socket
socket.connect();
# listen on events within channel
channel.on("created", orderCreatedEvent => {
  console.log("Got an order", orderCreatedEvent);
});
# join channel
channel
  .join()
  .receive("ok", ({ messages }) => console.log("catching up", messages))
  .receive("error", ({ reason }) => console.log("failed join", reason))
  .receive("timeout", () =>
    console.log("Networking issue. Still waiting...")
  );
```
