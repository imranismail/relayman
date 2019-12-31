# Relayman

This is a very minimal cloudevents server that can be used for producing events (HTTP) and consuming events (WebSocket through Phoenix Channel).

Don't worry if there are no activities as it is feature complete and very minimal. I will continously apply security patches reported by Github.

# Usage

Start the server

```
docker run -it -b 4000:4000 imranismail/relayman relayman start
```

### Consume Event

```js
import { Socket } from "phoenix";

let socket = new Socket("ws://localhost:4000/socket");

socket.connect();

let channel = socket.channel("source:/outlets/1/orders");

channel.on("created", orderCreatedEvent => {
  console.log("Got an order", orderCreatedEvent);
});

channel
  .join()
  .receive("ok", ({ messages }) => console.log("catching up", messages))
  .receive("error", ({ reason }) => console.log("failed join", reason))
  .receive("timeout", () =>
    console.log("Networking issue. Still waiting...")
  );
```

### Produce Event

#### Parameters

```elixir
requires :specversion, :string, default: "1.0"
requires :id, :string
requires :source, :string
requires :type, :string
optional :datacontenttype, :string
optional :dataschema, :string
optional :subject, :string
optional :time, :string
optional :data, :map
```

```sh
curl -X POST \
  http://localhost:4000/events \
  -H 'Content-Type: application/json' \
  -d '{"id":"uuid","source":"/outlets/1/orders","type":"created","subject":"1","data":{"id": "1", "items": ["Pizza", "Burger"]}}'
```
