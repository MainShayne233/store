defmodule Store.Map do
  use GenServer
  alias Store.ETS
  @moduledoc """
  Definition of the Map GenServer
  Basically a globally accessible, mutable map.
  """

  @doc """
  The API for creating an instance.

  ## Examples
  
    iex> Store.Map.start_link(:my_store)
    {:ok, pid}
  """
  def start_link(name, opts \\ []) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts ++ [name: name])
    Process.register(pid, name)
    {:ok, pid}
  end

  @doc """
  Inserts the key and value into the map
  """
  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
    pid
  end

  @doc """
  Replaces the map data with that of the passed in map
  """
  def set(pid, data) when data |> is_map do
    GenServer.cast(pid, {:set, data})
    pid
  end
  
  @doc """
  Removes the key and associated value from the map
  """
  def delete(pid, key) do
    GenServer.cast(pid, {:delete, key})
    pid
  end

  @doc """
  Returns the value for the specified key, nil if key doesn't exist
  """
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @doc """
  Returns the map's keys
  """
  def keys(pid) do
    GenServer.call(pid, :keys)
  end

  def init(opts) do
    table = ETS.create(opts[:name], [:ordered_set, :protected])
    data = ETS.create("__#{opts[:name]}_data__" |> String.to_atom, [:ordered_set, :protected])
    data |> ETS.insert({:keys, []})
    cond do
      opts[:init_data] -> 
        GenServer.cast(self(), {:set, opts[:init_data]})
      opts[:init_data_fun] ->
        GenServer.cast(self(), {:init_data_with_fun, opts[:init_data_fun], table})
      true ->
        :nothing
    end
    {:ok, %{table: table, __data__: data, opts: opts}}
  end

  def handle_cast({:put, key, value}, state = %{table: table, __data__: data}) do
    table
    |> ETS.insert({key, value})
    data
    |> ETS.insert({:keys, ETS.get(data, :keys) ++ [key]})
    {:noreply, state}
  end

  def handle_cast({:set, new_data}, state = %{table: table, __data__: data}) do
    table
    |> ETS.set( new_data |> Map.to_list )
    data
    |> ETS.insert({:keys, new_data |> Map.keys})
    {:noreply, state}
  end

  def handle_cast({:delete, key}, state = %{table: table, __data__: data}) do
    table
    |> ETS.delete(key)
    data
    |> ETS.insert({:keys, ETS.get(data, :keys) -- [key]})
    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state = %{table: table}) do
    {:reply, ETS.get(table, key), state}
  end

  def handle_call(:keys, _from, state = %{__data__: data}) do
    keys = data |> ETS.get(:keys)
    {:reply, keys, state}
  end
end
