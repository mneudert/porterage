defmodule Porterage.TesterTest do
  use ExUnit.Case, async: true

  test "test called after scheduler tick" do
    parent = self()

    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def tick, do: true
    end

    Code.compile_quoted(
      quote do
        defmodule DummyTester do
          @behaviour Porterage.Tester

          def init do
            send(unquote(parent), :init)
          end

          def test do
            send(unquote(parent), :test)
            false
          end
        end
      end
    )

    start_supervised({Porterage, %{scheduler: DummyScheduler, tester: DummyTester}})

    assert_receive :init
    assert_receive :test
  end
end
