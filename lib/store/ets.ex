defmodule Store.ETS do

  @moduledoc """
  API for dealing with ETS tables
  """

  @doc """
  returns a new ets table

  ## Example

    iex> Store.ETS.create(:my_table, [:ordered_set, :protected, :named_table])
    :my_table
  """
  def create(name, opts) do
    :ets.new(name, opts)
  end

  @doc """
  inserts data into the table depending on the type
  """
  def set(table, data) when data |> is_map do
    table
    |> insert( data |> Map.to_list )
  end

  @doc"""
  inserts key-value tuple(s) into table
  can be a single tuple, or list of tuples
  returns true if successful, argument errors otherwise
  """
  def insert(table, record) do
    table
    |> :ets.insert(record)
  end

  @doc """
  Returns the value stored for the specified key in tuple format
  {:ok, value}, {:error, :not_found}
  """
  def get(table, key) do
    table
    |> :ets.lookup(key)
    |> case do
      []              -> {:error, :not_found}
      [{^key, value}] -> {:ok, value}
    end
  end

  @doc """
  Return the value stored for the specified key
  """
  def get!(table, key) do
    table
    |> get(key)
    |> case do
      {:ok, value} -> value
      {:error, :not_found} -> nil
    end
  end
end
