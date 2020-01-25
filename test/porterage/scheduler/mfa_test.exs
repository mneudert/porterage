defmodule Porterage.Scheduler.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.MFA

  test "tick result defined by configured callable" do
    parent = self()

    Code.compile_quoted(
      quote do
        defmodule MFAScheduler do
          def tick, do: send(unquote(parent), :tick)
        end
      end
    )

    start_supervised(
      {Porterage,
       %{
         scheduler: MFA,
         scheduler_opts: %{mfa: {MFAScheduler, :tick, []}}
       }}
    )

    assert_receive :tick
  end
end
