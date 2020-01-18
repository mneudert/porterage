defmodule Porterage.Fetcher.FileRead do
  @moduledoc """
  Fetcher based on results of `File.read/1` calls.

  ## Configuration

      {
        fetcher: Porterage.Fetcher.FileRead,
        fetcher_opts: %{file :: Path.t()}
      }
  """

  @behaviour Porterage.Fetcher

  @impl Porterage.Fetcher
  def init(%{file: _} = state), do: state

  @impl Porterage.Fetcher
  def fetch(%{file: file} = state) do
    case File.read(file) do
      {:ok, contents} -> {:ok, state, contents}
      _ -> {:ok, state}
    end
  end
end
