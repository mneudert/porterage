defmodule Porterage.Fetcher.MFA do
  @moduledoc """
  Fetcher based on usage of `Kernel.apply/3` calls.
  """

  @behaviour Porterage.Fetcher

  @impl Porterage.Fetcher
  def init(%{mfa: {_, _, _}} = state), do: state

  @impl Porterage.Fetcher
  def fetch(%{mfa: {mod, fun, args}} = state) do
    case apply(mod, fun, args) do
      {:ok, contents} -> {:ok, state, contents}
      _ -> {:ok, state}
    end
  end
end
