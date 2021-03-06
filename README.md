# Store
Global data structures in Elixir

Current structures implemented:
- Map (Core API only)

## Usage
Add as mix dependency in `mix.exs`
```elixir
def deps do
  [
    {:store, github: "MainShayne233/store"}
  ]
end
```

### Map
```elixir
# Create a new map with a name (`PID` for the Map process gets registered with the name)
{:ok, map} = Store.Map.start_link(:my_global_map)

# Put some data into the map
map
|> Store.Map.put(:key, :value) # simple put function, just like Map.put
|> Store.Map.put(:other_key, :other_value)
|> Store.Map.merge(%{
  map_key: :map_value,
  another_map_key: :another_map_value,
}) # can also merge a map to insert multiple key-value pairs at once
#=>
PID<0.107.0> # PID is returned for functions where value isn't returned

# Get the data back
Store.Map.get(map, :key)
#=>
:value

Store.Map.get(map, :map_key)
#=>
:map_value

# Get the keys
Store.Map.keys(map)
#=>
[:key, :other_key, :map_key, :another_map_key]

# Get the values
Store.Map.values(map)
#=>
[:value, :other_value, :map_value, :another_map_value]
```
