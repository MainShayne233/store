defmodule Store.Test.ETS do
  use ExUnit.Case, async: true

  doctest Store.ETS

  test "insert/2 should insert the key-value tuple into the table, and return the table" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    assert table |> Store.ETS.insert({:key, :value}) == table
    assert table |> Store.ETS.insert([{:key1, :value}, {:key2, :value}]) == table
  end

  test "set/2 should clear the table, and insert the new data" do
    table =Store.ETS.create(:my_table, [:ordered_set, :protected])
    |> Store.ETS.insert({:key, :value})
    |> Store.ETS.set([{:new_key_1, :val1}, {:new_key_2, :val2}]) 
    assert table |> Store.ETS.get(:key) == nil
    assert table |> Store.ETS.get(:new_key_1) == :val1
    assert table |> Store.ETS.get(:new_key_2) == :val2
  end

  test "get/2 should return the value stored with the key, or nil if the key doesn't exist" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    table |> Store.ETS.insert({:key, :value})
    value = table |> Store.ETS.get(:key)
    assert value == :value
    value = table |> Store.ETS.get(:other_key)
    assert value == nil
  end

  test "clear/1 should clear and return the table" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    table |> Store.ETS.insert({:key, :value})
    assert table |> Store.ETS.clear == table
    assert table |> Store.ETS.get(:key) == nil
  end

  test "all/1 should return all the contents of the table" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    table |> Store.ETS.insert({:key, :value})
    table |> Store.ETS.insert({:other_key, :other_value})
    assert table |> Store.ETS.all == [{:key, :value}, {:other_key, :other_value}]
    table |> Store.ETS.clear
    assert table |> Store.ETS.all == []
  end

  test "delete/2 should remove the key and associated value from the table" do
    assert Store.ETS.create(:my_table, [:ordered_set, :protected])
    |> Store.ETS.insert({:key, :val})
    |> Store.ETS.delete(:key)
    |> Store.ETS.get(:key) == nil
  end
end
