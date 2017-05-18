defmodule Store.Test.Map do
  use ExUnit.Case, async: true

  test "should be able to be created" do
    {:ok, pid} = Store.Map.start_link(:my_store)

    assert Process.alive?(pid)
  end
end
