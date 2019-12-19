defmodule Porterage.Tester do
  @moduledoc """
  Porterage tester
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  def init([supervisor, tester]) do
    {:ok, %{supervisor: supervisor, tester: tester}}
  end
end
