# Store
Global data structures in Elixir

Current structures implemented:
- Map (Core API)

## Usage
Add as mix dependency in `mix.exs`
```elixir
def deps do
  [
    {:store, git: "git@github.com/MainShayne233/store.git"}
  ]
end
```

### Map
```elixir
# Create a new map with a name (`PID` for the Map process gets registered with the name)
{:ok, map} = Store.Map.start_link(:my_global_map)

# Put some data into the map
map
|> Store.Map.put(map, :key, :value) # simple put function, just like Map.put
|> Store.Map.put(map, :other_key, other_value)
|> Store.Map.merge(%{
  map_key: :map_value,
  another_map_key: :another_map_value,
}) # can also merge a map to insert multiple key-value pairs at once
#=>
:my_global_map # Map PID/name is returned for functions where value isn't returned

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
