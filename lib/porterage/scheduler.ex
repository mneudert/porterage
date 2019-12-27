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
    :ok = GenServer.cast(self(), :tick)

    {:ok, %{supervisor: supervisor, scheduler: scheduler}}
  end

  def handle_cast(:tick, %{scheduler: scheduler} = state) do
    scheduler.tick()

    {:noreply, state}
  end

  @doc """
  Execute a run of the tester module.
  """
  @callback tick() :: boolean
end
