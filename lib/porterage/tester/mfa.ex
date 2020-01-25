defmodule Porterage.Tester.MFA do
  @moduledoc """
  Tester based on usage of `Kernel.apply/3` calls.

  The configured callable will receive a `state` value as the first parameter.
  On the first run it will always be `nil` and afterwards the return value
  of the last execution.

  The return value is expected to be `{new_state, result}`.

  ## Configuration

      {
        tester: Porterage.Tester.MFA,
        tester_opts: %{mfa: {_, _, _}}
      }

  See `t:options/0` for a specification of available options.
  """

  @type options :: %{mfa: {module, atom, [any]}}

  @behaviour Porterage.Tester

  @impl Porterage.Tester
  def init(%{mfa: {_, _, _}} = state), do: state

  @impl Porterage.Tester
  def test(%{mfa: {mod, fun, args}} = state) do
    mfa_state = Map.get(state, :mfa_state)
    {mfa_state, result} = apply(mod, fun, [mfa_state | args])

    {Map.put(state, :mfa_state, mfa_state), result}
  end
end
