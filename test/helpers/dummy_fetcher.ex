defmodule Porterage.TestHelpers.DummyFetcher do
  @moduledoc false

  @behaviour Porterage.FetcherBehaviour

  @impl Porterage.FetcherBehaviour
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.FetcherBehaviour
  def fetch(%{parent: parent, return_fetch: return_fetch, send_fetch: send_fetch} = state) do
    send(parent, send_fetch)
    {:ok, state, return_fetch}
  end

  def fetch(%{return_fetch: return_fetch} = state), do: {:ok, state, return_fetch}

  def fetch(%{parent: parent, send_fetch: send_fetch} = state) do
    send(parent, send_fetch)
    {:ok, state}
  end

  def fetch(state), do: {:ok, state}
end
