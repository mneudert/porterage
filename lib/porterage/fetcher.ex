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
end
