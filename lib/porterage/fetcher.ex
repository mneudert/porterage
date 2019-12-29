defmodule Porterage.Fetcher do
  @moduledoc """
  Porterage fetcher
  """

  use GenServer

  @doc false
  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  @doc false
  def init([supervisor, fetcher]) do
    {:ok, %{supervisor: supervisor, fetcher: fetcher}}
  end

  def handle_cast(:fetch, %{fetcher: fetcher} = state) do
    case fetcher.fetch() do
      {:ok, data} -> notify_deliverer(state, data)
      _ -> :ok
    end

    {:noreply, state}
  end

  @doc """
  Execute a run of the fetcher module.
  """
  @callback fetch() :: {:ok, any} | any

  defp notify_deliverer(%{supervisor: supervisor}, data) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.each(fn
      {Porterage.Deliverer, deliverer, :worker, _} -> GenServer.cast(deliverer, {:deliver, data})
      _ -> nil
    end)
  end
end
