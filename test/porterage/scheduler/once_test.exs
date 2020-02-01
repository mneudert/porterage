defmodule Porterage.Scheduler.OnceTest do
  use ExUnit.Case, async: true

  alias Porterage.Scheduler.Once
  alias Porterage.TestHelpers.DummyTester

  test "tick returning true during startup" do
    start_supervised!(
      {Porterage,
       %{
         scheduler: Once,
         tester: DummyTester,
         tester_opts: %{parent: self(), return_test: false, send_test: :test}
       }}
    )

    assert_receive :test
  end
end
