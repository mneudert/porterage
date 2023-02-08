defmodule Porterage.Deliverer.MFArgs do
  @moduledoc """
  Deliverer based on usage of `Kernel.apply/3` calls.

  Data to be delivered will be passed as the first argument.

  ## Configuration

      {
        deliverer: Porterage.Deliverer.MFArgs,
        deliverer_opts: %{mfargs: {_, _, _}}
      }

  Data to be delivered will always be passed as the first argument with all
  configured arguments afterwards.

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfargs: {module, atom, [any]}}

  @behaviour Porterage.DelivererBehaviour

  @impl Porterage.DelivererBehaviour
  def init(%{mfargs: {_, _, _}} = state), do: state

  @impl Porterage.DelivererBehaviour
  def deliver(%{mfargs: {mod, fun, args}} = state, data) do
    apply(mod, fun, [data | args])
    state
  end
end
