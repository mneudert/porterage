defmodule Porterage.Tester do
  @moduledoc """
  Porterage tester
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, tester]) do
    {:ok, %{supervisor: supervisor, tester: tester}}
  end

  def handle_cast(:test, %{tester: tester} = state) do
    tester.test()

    {:noreply, state}
  end

  @doc """
  Execute a run of the tester module.
  """
  @callback test() :: boolean
end
