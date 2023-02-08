defmodule Porterage.Fetcher.FileRead do
  @moduledoc """
  Fetcher based on results of `File.read/1` calls.

  ## Configuration

      {
        fetcher: Porterage.Fetcher.FileRead,
        fetcher_opts: %{file: _}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{file: Path.t()}

  @behaviour Porterage.FetcherBehaviour

  @impl Porterage.FetcherBehaviour
  def init(%{file: _} = state), do: state

  @impl Porterage.FetcherBehaviour
  def fetch(%{file: file} = state) do
    case File.read(file) do
      {:ok, contents} -> {:ok, state, contents}
      _ -> {:ok, state}
    end
  end
end
