defmodule Porterage.SchedulerTest do
  use ExUnit.Case, async: true

  test "tick called after start" do
    parent = self()

    Code.compile_quoted(
      quote do
        defmodule DummyScheduler do
          @behaviour Porterage.Scheduler

          def tick do
            send(unquote(parent), :tick)
            false
          end
        end
      end
    )

    start_supervised({Porterage, %{scheduler: DummyScheduler}})
    assert_receive :tick
  end
end
