defmodule Porterage.Deliverer do
  @moduledoc """
  Porterage deliverer
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  def init([supervisor, deliverer]) do
    {:ok, %{supervisor: supervisor, deliverer: deliverer}}
  end
end
