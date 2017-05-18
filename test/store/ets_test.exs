defmodule Store.Test.ETS do
  use ExUnit.Case, async: true

  doctest Store.ETS

  test "insert/2 should insert the key-value tuple into the table" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    assert table |> Store.ETS.insert({:key, :value}) == true
    assert table |> Store.ETS.insert([{:key1, :value}, {:key2, :value}]) == true
  end

  test "get/2 should return the value stored for the specified key" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    table |> Store.ETS.insert({:key, :value})
    {:ok, value} = table |> Store.ETS.get(:key)
    assert value == :value
    {:error, value} = table |> Store.ETS.get(:other_key)
    assert value == :not_found
  end

  test "get!/2 should be the same as get/2, but returns just the value" do
    table = Store.ETS.create(:my_table, [:ordered_set, :protected])
    table |> Store.ETS.insert({:key, :value})
    value = table |> Store.ETS.get!(:key)
    assert value == :value
    value = table |> Store.ETS.get!(:other_key)
    assert value == nil
  end

  test "set/2 should "
end
