defmodule Store.ETS do

  @moduledoc """
  API for dealing with ETS tables
  """

  @doc """
  Returns a new ets table

  ## Example

    iex> Store.ETS.create(:my_table, [:ordered_set, :protected, :named_table])
    :my_table
  """
  def create(name, opts) do
    :ets.new(name, opts)
  end

  @doc """
  Inserts key-value tuple(s) into table
  Can be a single tuple, or list of tuples
  Returns true if successful, argument errors otherwise
  """
  def insert(table, record) do
    table
    |> :ets.insert(record)
    table
  end

  @doc """
  Inserts many values for single key (for :bag type tables)
  """
  def insert_many(table, {key, values}) when values |> is_list do
    table
    |> insert( values |> Enum.map(&( {key, &1} )) )
  end

  @doc """
  Removes the entry in the table for the specified key, if any
  """
  def delete(table, key) do
    table
    |> :ets.delete(key)
    table
  end

  @doc """
  Removes the values for the specified key (for :bag type tables)
  """
  def delete_many(table, {key, values}) when values |> is_list do
    table
    |> insert_many( {key, pop_many(table, key) -- values} )
  end

  @doc """
  Removes and returns the entry from table
  """
  def pop(table, key) do
    value = get(table, key)
    delete(table, key)
    value
  end

  @doc """
  Removes and returns the entries from the table
  """
  def pop_many(table, key) do
    values = get_all(table, key)
    delete(table, key)
    values
  end

  @doc """
  Removes the entries for the given keys from the table
  """
  def drop(table, keys) when keys |> is_list do
    keys
    |> Enum.each(&( delete(table, &1) ))
    table
  end

  @doc """
  Clears the table, then inserts the new data
  """
  def set(table, data) do
    table
    |> clear
    |> insert(data)
  end

  @doc """
  Returns the value stored for the specified key, or nil if the key doesn't exist
  """
  def get(table, key) do
    table
    |> :ets.lookup(key)
    |> case do
      []              -> nil
      [{^key, value}] -> value
    end
  end

  @doc """
  Returns all values stored for the specified key (used for bag ETS tables)
  """
  def get_all(table, key) do
    table
    |> :ets.lookup(key)
    |> Enum.map(fn {^key, value} -> value end)
  end

  @doc """
  Returns all of the key value pairs in the table
  """
  def all(table) do
    table
    |> :ets.match({:"$1", :"$2"})
    |> Enum.map(fn [key, val] -> {key, val} end)
  end

  @doc """
  Should completely clear the ETS table
  """
  def clear(table) do
    table |> :ets.delete_all_objects
    table
  end
end
