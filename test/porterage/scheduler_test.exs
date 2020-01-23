defmodule Porterage.SchedulerTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyScheduler

  test "tick called after start" do
    start_supervised(
      {Porterage,
       %{
         scheduler: DummyScheduler,
         scheduler_opts: %{parent: self(), return_tick: false, send_init: :init, send_tick: :tick}
       }}
    )

    assert_receive :init
    assert_receive :tick
  end
end
