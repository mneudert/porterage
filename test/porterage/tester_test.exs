defmodule Porterage.TesterTest do
  use ExUnit.Case, async: true

  alias Porterage.TestHelpers.DummyScheduler

  test "test called after scheduler tick" do
    defmodule DummyTester do
      @behaviour Porterage.Tester

      def init(parent) do
        send(parent, :init)
        parent
      end

      def test(parent) do
        send(parent, :test)
        false
      end
    end

    start_supervised(
      {Porterage,
       %{
         scheduler: DummyScheduler,
         scheduler_opts: %{return_tick: true},
         tester: DummyTester,
         tester_opts: self()
       }}
    )

    assert_receive :init
    assert_receive :test
  end
end
