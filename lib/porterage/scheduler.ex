defmodule Porterage.Scheduler do
  @moduledoc """
  Porterage scheduler
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, scheduler]) do
    {:ok, %{supervisor: supervisor, scheduler: scheduler}}
  end
end
