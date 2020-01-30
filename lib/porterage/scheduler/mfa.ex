defmodule Porterage.Scheduler.MFA do
  @moduledoc """
  Scheduler based on usage of `Kernel.apply/3` calls.

  The configured function to call is required to send a message to `self()`
  in order to schedule the next tick:

      GenServer.cast(self(), :tick)
      Kernel.send(self(), :tick)
      Process.send_after(self(), :tick, send_after)

  ## Configuration

      {
        scheduler: Porterage.Scheduler.MFA,
        scheduler_opts: %{mfa: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfa: {module, atom, [any]}}

  @behaviour Porterage.Scheduler

  @impl Porterage.Scheduler
  def init(%{mfa: {_, _, _}} = state), do: state

  @impl Porterage.Scheduler
  def tick(%{mfa: {mod, fun, args}} = state) do
    {state, apply(mod, fun, args)}
  end
end
