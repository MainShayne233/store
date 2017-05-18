defmodule Store.Test.Map do
  use ExUnit.Case, async: true

  test "start_link/1 should create the Map process" do
    {:ok, pid} = Store.Map.start_link(:my_store)
    assert Process.alive?(pid)
  end

  test "put/3 should insert the key and value into the map" do
    {:ok, map} = Store.Map.start_link(:my_store)
    assert map |> Store.Map.put(:key, :value) == map
    assert map |> Store.Map.get(:key) == :value
  end

  test "get/2 should return the value for the key, nil if doesn't exist" do
    {:ok, map} = Store.Map.start_link(:my_store)
    map |> Store.Map.put(:key, :value)
    assert map |> Store.Map.get(:key) == :value
    map |> Store.Map.put(:key, :new_value)
    assert map |> Store.Map.get(:key) == :new_value
  end

  test "set/2 should set the value of the map to the passed in map" do
    {:ok, map} = Store.Map.start_link(:my_store)
    map |> Store.Map.put(:key_to_be_cleared, :value)
    assert map |> Store.Map.set(%{new_key: :new_value}) == map
    assert map |> Store.Map.get(:key_to_be_cleared) == nil
    assert map |> Store.Map.get(:new_key) == :new_value
  end

  test "keys/1 should return the keys for the map" do
    {:ok, map} = Store.Map.start_link(:my_store)
    assert map
    |> Store.Map.put(:key1, :val1)
    |> Store.Map.put(:key2, :val2)
    |> Store.Map.keys == [:key1, :key2]
  end

  test "delete/2 should delete the key and associated value from the map" do
    {:ok, map} = Store.Map.start_link(:my_store)
    map
    |> Store.Map.put(:key1, :val1)
    |> Store.Map.put(:key2, :val2)
    |> Store.Map.delete(:key1)
    assert map |> Store.Map.get(:key1) == nil
    assert map |> Store.Map.get(:key2) == :val2
  end

  test "drop/2 should delete the keys and associated values from the map" do
    {:ok, map} = Store.Map.start_link(:my_store)
    map
    |> Store.Map.put(:key1, :val1)
    |> Store.Map.put(:key2, :val2)
    |> Store.Map.put(:key3, :val3)
    |> Store.Map.drop([:key1, :key3])
    assert map |> Store.Map.get(:key1) == nil
    assert map |> Store.Map.get(:key2) == :val2
    assert map |> Store.Map.get(:key3) == nil
  end
end
