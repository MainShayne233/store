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

  def init(opts) do
    table = ETS.create(opts[:name], [:ordered_set, :protected])
    cond do
      opts[:init_data] -> 
        ETS.set(table, opts[:init_data])
      opts[:init_data_fun] ->
        GenServer.cast(self(), {:init_data_with_fun, opts[:init_data_fun], table})
      true ->
        ETS.set(table, %{})
    end
    {:ok, %{table: table, opts: opts}}
  end
end
