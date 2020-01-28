defmodule Porterage.Scheduler.MFATest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.MFA

  test "tick result defined by configured callable" do
    defmodule MFAScheduler do
      def tick(notify_pid), do: send(notify_pid, :tick)
    end

    start_supervised(
      {Porterage,
       %{
         scheduler: MFA,
         scheduler_opts: %{mfa: {MFAScheduler, :tick, [self()]}}
       }}
    )

    assert_receive :tick
  end
end
