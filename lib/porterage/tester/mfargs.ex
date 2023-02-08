defmodule Porterage.Tester.MFArgs do
  @moduledoc """
  Tester based on usage of `Kernel.apply/3` calls.

  The configured callable will receive a `state` value as the first parameter.
  On the first run it will always be `nil` and afterwards the return value
  of the last execution.

  The return value is expected to be `{new_state, result}`.

  ## Configuration

      {
        tester: Porterage.Tester.MFArgs,
        tester_opts: %{mfargs: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfargs: {module, atom, [any]}}

  @behaviour Porterage.TesterBehaviour

  @impl Porterage.TesterBehaviour
  def init(%{mfargs: {_, _, _}} = state), do: state

  @impl Porterage.TesterBehaviour
  def test(%{mfargs: {mod, fun, args}} = state) do
    mfargs_state = Map.get(state, :mfargs_state)
    {mfargs_state, result} = apply(mod, fun, [mfargs_state | args])

    {Map.put(state, :mfargs_state, mfargs_state), result}
  end
end
