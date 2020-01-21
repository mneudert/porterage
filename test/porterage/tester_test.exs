defmodule Porterage.TesterTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyScheduler
  alias Porterage.TestHelpers.DummyTester

  test "test called after scheduler tick" do
    start_supervised(
      {Porterage,
       %{
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: %{parent: self(), return_test: false, send_init: :init, send_test: :test}
       }}
    )

    assert_receive :init
    assert_receive :test
  end

  test "missing tester is ignored" do
    sup_pid = start_supervised!({Porterage, %{}})

    assert :error == Porterage.test(sup_pid)
  end
end
