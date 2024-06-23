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
