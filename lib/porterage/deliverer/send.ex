defmodule Porterage.Deliverer.Send do
  @moduledoc """
  Deliverer based on usage of `Kernel.send/2` calls.

  ## Configuration

      {
        deliverer: Porterage.Deliverer.Send,
        deliverer_opts: %{dest: _}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{dest: Process.dest()}

  @behaviour Porterage.DelivererBehaviour

  @impl Porterage.DelivererBehaviour
  def init(%{dest: _} = state), do: state

  @impl Porterage.DelivererBehaviour
  def deliver(%{dest: dest} = state, data) do
    send(dest, data)
    state
  end
end
