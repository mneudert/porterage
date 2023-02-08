defmodule Porterage.Fetcher.MFArgs do
  @moduledoc """
  Fetcher based on usage of `Kernel.apply/3` calls.

  The configured callable is expected to return `{:ok, term}` if data has been
  fetched. Any other return value will be ignored.

  ## Configuration

      {
        fetcher: Porterage.Fetcher.MFArgs,
        fetcher_opts: %{mfargs: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfargs: {module, atom, [any]}}

  @behaviour Porterage.FetcherBehaviour

  @impl Porterage.FetcherBehaviour
  def init(%{mfargs: {_, _, _}} = state), do: state

  @impl Porterage.FetcherBehaviour
  def fetch(%{mfargs: {mod, fun, args}} = state) do
    case apply(mod, fun, args) do
      {:ok, contents} -> {:ok, state, contents}
      _ -> {:ok, state}
    end
  end
end
