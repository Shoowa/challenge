# Challenge

## Setup
```bash
~/challenge $ mix deps.get
~/challenge $ mix compile
~/challenge $ mix dialyzer
~/challenge $ mix test
~/challenge $ mix docs
```

## Concept
Many identically named entries from the original file with differing details will be ignored. This implementation assumes that a consumer simply wants to
identify the name of a foodtruck that serves a particular dish. And that the consumer can track down the foodtruck via other means, such as social media. If
this application were built for a  municipal bureaucracy, perhaps all the various locations and relevant permits would be written to the cache, too.

## Cache
An ETS table serves as the in-memory cache. Only the process named `Cache` can write data to the table. Every table row looks like the following:
```elixir
{"foodTruckName", %{"mapKey": "value", "mapKey2": "value2"}}
```

Each key in the table is unique, because the table is configured as a `set`. And once written, a key can't be re-written, because of the following line:
```elixir
:ets.insert_new(@table, d)
```

A simple Client API exists for other processes to read particular data from the cache, such as `read_vendor()` & `read_food()`.

## Router
A web server offers un-secured JSON responses, and properly terminates TCP connections after transactions complete. The web server offers a route for checking the health of the application. If this application relied on a database, an additional route for reporting the status of a connection to that dependency would be valuable.


## Operate
Open two separate terminals, and use [httpie](https://httpie.io/docs/cli) to request data.
```bash
~/challenge $ MIX_ENV=prod mix release demo #terminal 1
~/challenge $ _build/prod/rel/demo/bin/demo start #terminal 1
~/challenge $ http get "localhost:8888/health" #terminal 2
~/challenge $ http get "localhost:8888/v0/vendor/Natan's Catering" #terminal 2
~/challenge $ http get "localhost:8888/v0/food/burger" #terminal 2
```
