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
    if scheduler.tick() do
      :ok = notify_tester(state)
    end

    {:noreply, state}
  end

  defp notify_tester(%{supervisor: supervisor}) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.each(fn
      {Porterage.Tester, tester, :worker, _} -> GenServer.cast(tester, :test)
      _ -> nil
    end)
  end

  @doc """
  Execute a run of the scheduler module.
  """
  @callback tick() :: boolean
end
