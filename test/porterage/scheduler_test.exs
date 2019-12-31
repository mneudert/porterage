defmodule Porterage.SchedulerTest do
  use ExUnit.Case, async: true

  test "tick called after start" do
    parent = self()

    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def init(parent) do
        send(parent, :init)
        parent
      end

      def tick(parent) do
        send(parent, :tick)
        false
      end
    end

    start_supervised({Porterage, %{scheduler: DummyScheduler, scheduler_opts: self()}})

    assert_receive :init
    assert_receive :tick
  end
end
