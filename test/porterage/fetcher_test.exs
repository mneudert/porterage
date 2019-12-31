defmodule Porterage.FetcherTest do
  use ExUnit.Case, async: true

  test "fetch called after tester test" do
    parent = self()

    defmodule DummyScheduler do
      @behaviour Porterage.Scheduler

      def tick(_), do: true
    end

    defmodule DummyTester do
      @behaviour Porterage.Tester

      def test(_), do: true
    end

    Code.compile_quoted(
      quote do
        defmodule DummyFetcher do
          @behaviour Porterage.Fetcher

          def fetch(:substate) do
            send(unquote(parent), :fetch)
            :nodata
          end

          def init do
            send(unquote(parent), :init)
            :substate
          end
        end
      end
    )

    start_supervised(
      {Porterage, %{fetcher: DummyFetcher, scheduler: DummyScheduler, tester: DummyTester}}
    )

    assert_receive :init
    assert_receive :fetch
  end
end
