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

          def test do
            send(unquote(parent), :test)
            true
          end
        end
      end
    )

    start_supervised({Porterage, %{scheduler: DummyScheduler, tester: DummyTester}})
    assert_receive :test
  end
end
