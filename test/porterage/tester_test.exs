defmodule Porterage.TesterTest do
  use ExUnit.Case, async: true

  test "test called after scheduler tick" do
    parent = self()

    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def tick(_), do: true
    end

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
      {Porterage, %{scheduler: DummyScheduler, tester: DummyTester, tester_opts: self()}}
    )

    assert_receive :init
    assert_receive :test
  end
end
