defmodule Porterage.Deliverer.MFA do
  @moduledoc """
  Deliverer based on usage of `Kernel.apply/3` calls.

  Data to be delivered will be passed as the first argument.

  ## Configuration

      {
        deliverer: Porterage.Deliverer.MFA,
        deliverer_opts: %{mfa: {_, _, _}}
      }

  Data to be delivered will always be passed as the first argument with all
  configured arguments afterwards.

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfa: {module, atom, [any]}}

  @behaviour Porterage.Deliverer

  @impl Porterage.Deliverer
  def init(%{mfa: {_, _, _}} = state), do: state

  @impl Porterage.Deliverer
  def deliver(%{mfa: {mod, fun, args}} = state, data) do
    apply(mod, fun, [data | args])
    state
  end
end
