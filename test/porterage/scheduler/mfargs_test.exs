defmodule Porterage.Scheduler.MFArgsTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.MFArgs

  test "tick result defined by configured callable" do
    defmodule MFArgsScheduler do
      def tick(notify_pid), do: send(notify_pid, :tick)
    end

    start_supervised!({
      Porterage,
      %{
        scheduler: MFArgs,
        scheduler_opts: %{mfargs: {MFArgsScheduler, :tick, [self()]}}
      }
    })

    assert_receive :tick
  end
end
