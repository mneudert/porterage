defmodule Porterage.Scheduler.MFArgs do
  @moduledoc """
  Scheduler based on usage of `Kernel.apply/3` calls.

  The configured function to call is required to send a message to `self()`
  in order to schedule the next tick:

      GenServer.cast(self(), :tick)
      Kernel.send(self(), :tick)
      Process.send_after(self(), :tick, send_after)

  ## Configuration

      {
        scheduler: Porterage.Scheduler.MFArgs,
        scheduler_opts: %{mfargs: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfargs: {module, atom, [any]}}

  @behaviour Porterage.Scheduler

  @impl Porterage.Scheduler
  def init(%{mfargs: {_, _, _}} = state), do: state

  @impl Porterage.Scheduler
  def tick(%{mfargs: {mod, fun, args}} = state) do
    {state, apply(mod, fun, args)}
  end
end
