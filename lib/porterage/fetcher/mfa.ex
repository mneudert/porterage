defmodule Porterage.Fetcher.MFA do
  @moduledoc """
  Fetcher based on usage of `Kernel.apply/3` calls.

  ## Configuration

      {
        fetcher: Porterage.Fetcher.MFA,
        fetcher_opts: %{mfa: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfa: {module, atom, [any]}}

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
