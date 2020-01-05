defmodule Porterage.Scheduler.TimerTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Timer
  alias Porterage.TestHelpers.DummyTester

  test "tick returning true during startup" do
    start_supervised(
      {Porterage,
       %{
         scheduler: Timer,
         scheduler_opts: %{time: 1000},
         tester: DummyTester,
         tester_opts: %{parent: self(), return_test: false, send_test: :test}
       }}
    )

    assert_receive :test
    assert_receive :test, 2500
  end
end
