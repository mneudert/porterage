defmodule Porterage.TestHelpers.DummyFetcher do
  @moduledoc false

  @behaviour Porterage.Fetcher

  @impl Porterage.Fetcher
  def init(%{parent: parent, send_init: send_init} = state) do
    send(parent, send_init)
    state
  end

  def init(state), do: state

  @impl Porterage.Fetcher
  def fetch(%{parent: parent, return_fetch: return_fetch, send_fetch: send_fetch}) do
    send(parent, send_fetch)
    return_fetch
  end

  def fetch(%{return_fetch: return_fetch}), do: return_fetch
end
