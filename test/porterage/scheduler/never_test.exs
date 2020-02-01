defmodule Porterage.Scheduler.NeverTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Never
  alias Porterage.TestHelpers.DummyTester

  test "tick does not return true" do
    sup_pid =
      start_supervised!(
        {Porterage,
         %{
           scheduler: Never,
           tester: DummyTester,
           tester_opts: %{parent: self(), return_test: false, send_test: :test}
         }}
      )

    Porterage.tick(sup_pid)

    refute_receive _, 100
  end
end
